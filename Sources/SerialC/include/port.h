#ifndef port_h
#define port_h

int open_port(const char* port_location);
int close_port(const int file_descriptor);

//turn off blocking
//turn on  blocking

#endif /* port_h */