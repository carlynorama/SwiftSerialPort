#ifndef reading_h
#define reading_h

#include <unistd.h>

size_t noblock_read_from_port(const int file_descriptor, void * buffer, const size_t count);
size_t default_read_from_port(const int file_descriptor, void * buffer, const size_t count);
size_t bytes_available(const int file_descriptor, int * byte_count);
size_t read_line_from_port(const int file_descriptor, void * output_buffer, const size_t count);
//size_t read_until(const int file_descriptor, void * buffer, const size_t count);

#endif /* reading_h */