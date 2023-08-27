#include "port.h"
#include <mach/arm/boolean.h>
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */

/*
* 'open_port()' - Open serial port 1.
*
* Returns the file descriptor on success or -1 on error.
* https://www.msweet.org/serial/serial.html#listing1
*/

int
open_port(const char* port_location)
{
    int file_descriptor; /* File descriptor for the port */

    //O_RDWR = read write mode
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

int close_port(const int file_descriptor) {
  return close(file_descriptor);
}


/* Set the O_NONBLOCK flag of desc if value is nonzero,
   or clear the flag if value is 0.
   Return 0 on success, or -1 on error with errno set. */

int
set_flag (int file_descriptor, int flag, boolean_t on)
{
  int current_flags = fcntl (file_descriptor, F_GETFL, 0);
  /* If reading the flags failed, return error indication now. */
  if (current_flags == -1)
    return -1;
  /* Set just the flag we want to set. */
  if (on)
    current_flags |= flag;
  else
    current_flags &= ~flag;
  /* Store modified flag word in the descriptor. */
  return fcntl (file_descriptor, F_SETFL, current_flags);
}