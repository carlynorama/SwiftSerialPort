/*
//  port.h
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.
*/
#ifndef port_h
#define port_h

//#include <stdio.h>   /* Standard input/output definitions */
#include <termios.h> /* POSIX terminal control definitions */

int open_port(const char* port_location);
int close_port(const int file_descriptor);
int flush_port(const int file_descriptor);

int validate_baudrate(const int rate_to_check, speed_t* rate_to_use);
int update_baudrate(const int file_descriptor, const speed_t new_rate, const int when);

#endif /* port_h */
