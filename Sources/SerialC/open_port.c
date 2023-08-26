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

    file_descriptor = open(port_location, O_RDWR | O_NOCTTY | O_NDELAY);
    if (file_descriptor == -1)
        perror("open_port: Unable to open"); //TODO: How will swift handle these? 
    else
        fcntl(file_descriptor, F_SETFL, 0);
    return (file_descriptor);
}