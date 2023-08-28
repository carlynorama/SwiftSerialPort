/*
//  port.c
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.
*/
#include "port.h"
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */
#include <sys/ioctl.h>
/*
* 'open_port()' - Open serial port 1.
*
* Returns the file descriptor on success or -1 on error.
* https://www.msweet.org/serial/serial.html#listing1
*/

//MARK: Open
int
open_port(const char* port_location)
{
    int file_descriptor; /* File descriptor for the port */

    //O_RDWR = read write mode. Defined in fcntl.h
    //O_NOCTTY = this is not a controlling terminal
    //O_NDELAY = ignore DCD line setting (whether the other end of the port is up and running)
    //           will sleep process until DCD signal line is in space voltage. 
    file_descriptor = open(port_location, O_RDWR | O_NOCTTY | O_NDELAY);
    if (file_descriptor == -1)
        perror("open_port: Unable to open"); //TODO: How will swift handle these? 
    else
        //clears many of the flags
        //TODO: more specificity?
        //https://stackoverflow.com/questions/34943745/why-fcntlfd-f-setfl-0-use-in-serial-port-programming
        fcntl(file_descriptor, F_SETFL, 0);
    return (file_descriptor);
}
//MARK: Close
int close_port(const int file_descriptor) {
  return close(file_descriptor);
}

//MARK: Flush
int flush_port(int file_descriptor)
{
    usleep(1000);
    return tcflush(file_descriptor, TCIOFLUSH);
    //wanted to use one of the below but TCFLSH is not defined?
    //ioctl(fd, TCFLSH, 0); // flush receive
    //ioctl(fd, TCFLSH, 1); // flush transmit
    //ioctl(file_descriptor, TCFLSH, 2); // flush both
}


//MARK: Settings

int validate_baudrate(const int rate_to_check, speed_t* rate_to_use) {
    switch(rate_to_check) {
    case 9600:   *rate_to_use=B9600;   return 0;
    case 57600:  *rate_to_use=B57600;  return 0;
    case 115200: *rate_to_use=B115200; return 0;

#ifdef B14400
    case 14400:  *rate_to_use=B14400;  return 0;
#endif
    case 19200:  *rate_to_use=B19200;  return 0;
#ifdef B28800
    case 28800:  *rate_to_use=B28800;  return 0;
#endif
    case 38400:  *rate_to_use=B38400;  return 0;
    case 76800:  *rate_to_use=B76800;  return 0;
    case 230400: *rate_to_use=B230400; return 0;

    //less common
    case 0:      *rate_to_use=B0;      return 0;
    case 50:     *rate_to_use=B50;     return 0;
    case 75:     *rate_to_use=B75;     return 0;
    case 110:    *rate_to_use=B110;    return 0;
    case 134:    *rate_to_use=B134;    return 0;
    case 150:    *rate_to_use=B150;    return 0;
    case 200:    *rate_to_use=B200;    return 0;
    case 300:    *rate_to_use=B300;    return 0;
    case 600:    *rate_to_use=B600;    return 0;
    case 1200:   *rate_to_use=B1200;   return 0;
    case 1800:   *rate_to_use=B1800;   return 0;
    case 2400:   *rate_to_use=B2400;   return 0;
    case 4800:   *rate_to_use=B4800;   return 0;
#ifdef B7200
    case 7200:   *rate_to_use=B7200;   return 0;
#endif

//TODO: Each of these should get their independent ifdefs, really. 
//This is the Linux only batch. 
#ifdef B460800
    case 460800:   *rate_to_use=B460800;   return 0;
    case 500000:   *rate_to_use=B500000;   return 0;
    case 576000:   *rate_to_use=B576000;   return 0;
    case 921600:   *rate_to_use=B921600;   return 0;
    case 1000000:   *rate_to_use=B1000000;   return 0;
    case 1152000:   *rate_to_use=B1152000;   return 0;
    case 1500000:   *rate_to_use=B1500000;   return 0;
    case 2000000:   *rate_to_use=B2000000;   return 0;
    case 2500000:   *rate_to_use=B2500000;   return 0;
    case 3500000:   *rate_to_use=B3500000;   return 0;
    case 4000000:   *rate_to_use=B4000000;   return 0;
#endif
    }
    *rate_to_use = rate_to_check;
    return -1;

}

//MARK: Settings

int update_baudrate(const int file_descriptor, const speed_t new_rate, const int when) {
  struct termios current_settings;
  int r;

  r = tcgetattr(file_descriptor, &current_settings);
  if (r < 0) { 
    perror("update_baudrate: couldn't get current settings");
    return -1;
  }

  cfsetispeed(&current_settings, new_rate);
  cfsetospeed(&current_settings, new_rate);

  r = tcsetattr(file_descriptor, when, &current_settings);
  if (r < 0) {
      perror("update_baudrate: couldn't set baud rate");
      return -2;
  }
  return 0;
}

//assumes the following style opening.
//    fd = open("/dev/ttyS0", O_RDWR | O_NOCTTY | O_NDELAY);
//    fcntl(fd, F_SETFL, 0);
int set_early_fail_behavior(const int file_descriptor, const cc_t new_vtime, const cc_t new_vmin) {
      /* get the current options */
    int r;
    struct termios settings;
    tcgetattr(file_descriptor, &settings);
    if (r < 0) { 
        perror("update_baudrate: couldn't get current settings");
        return -1;
    }

    settings.c_cc[VTIME] = new_vtime;//10;
    settings.c_cc[VMIN]  = new_vmin; //0

    /* set the options */
    tcsetattr(file_descriptor, TCSANOW, &settings);
    if (r < 0) {
      perror("update_baudrate: couldn't set VTIME and VMIN");
      return -2;
    }
    return 0;
}