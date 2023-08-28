/*
//  reading.c
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.
*/
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */ // (memcpy)
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
//#include <errno.h>   /* Error number definitions */
//#include <termios.h> /* POSIX terminal control definitions */
#include <sys/ioctl.h>

//TODO: Would be better to read the current flags and then restore. 
size_t noblock_read_from_port(const int file_descriptor, void * buffer, const size_t count) {
    fcntl(file_descriptor, F_SETFL, FNDELAY);
    int result = read(file_descriptor, buffer, count);
    fcntl(file_descriptor, F_SETFL, 0);
    return result;
}

//Uses port settings. 
size_t default_read_from_port(const int file_descriptor, void * buffer, const size_t count) {
    int result = read(file_descriptor, buffer, count);
    return result;
}

size_t bytes_available(const int file_descriptor, int * byte_count) {
    return ioctl(file_descriptor, FIONREAD, byte_count);
}


//     fcntl(fd, F_SETFL, FNDELAY);
// The FNDELAY option causes the read function to return 0 if no characters are available on the port. To restore normal (blocking) behavior, call fcntl() without the FNDELAY option:
//return it to normal
//     fcntl(fd, F_SETFL, 0);
// This is also used after opening a serial port with the O_NDELAY option.
