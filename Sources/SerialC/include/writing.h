/*
//  writing.h
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.
*/
#ifndef writing_h
#define writing_h

#include <unistd.h>

size_t write_to_port(const int file_descriptor, const void * buffer, const size_t count);
size_t write_test_to_port(const int file_descriptor);

#endif /* writing_h */
