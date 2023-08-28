/*
//  writing.c
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.
*/
#include <stdio.h>   /* Standard input/output definitions */
//#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
//#include <fcntl.h>   /* File control definitions */
//#include <errno.h>   /* Error number definitions */
//#include <termios.h> /* POSIX terminal control definitions */

size_t write_test_to_port(const int file_descriptor) {
    size_t n = write(file_descriptor, "A", 1);
    if (n < 0)
      fputs("write() failed!\n", stderr);
    return n;
}

size_t write_to_port(const int file_descriptor, const void * buffer, const size_t count) {
    size_t n = write(file_descriptor, "A", 1);
    if (n < 0)
      fputs("write() failed!\n", stderr);
    return n;
}

