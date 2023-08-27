#ifndef port_h
#define port_h

//#include <stdio.h>   /* Standard input/output definitions */
#include <termios.h> /* POSIX terminal control definitions */

int open_port(const char* port_location);
int close_port(const int file_descriptor);

int update_baudrate(const int file_descriptor, const int new_rate, const int when);

#endif /* port_h */