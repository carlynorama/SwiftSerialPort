# SwiftSerialPort

WARNING: works, but very version 0.0.0

Foundationless, dependency free library for talking to a serial port on MacOS or Linux with a focus on talking to hobby boards like the Arduino. 

Special thanks to the [SwiftSerial](https://swiftpackageindex.com/yeokm1/SwiftSerial) library to help do a quick start proof of concept. I wanted a different structure for what I was doing but it's still a great starting place. 

See also 
- https://github.com/carlynorama/SerialSession/ : library that includes this as a dependency to manage the serial port at a higher level. Uses Foundation types. Also very alpha-mode
- https://github.com/carlynorama/SerialSessionUI : MacOS/SwiftUI project that demonstrates usage of Session library. 


## TODO
- lock port ->  make is port in use function
- make flush async to accommodate required sleep. 

## References
- On your machine, find and open termios.h (macOS spotlight finds it fine.)

- https://www.msweet.org/serial/serial.html

### Other Serial Libraries
- https://github.com/todbot/arduino-serial/
- https://swiftpackageindex.com/yeokm1/SwiftSerial
    - Author's talk: https://www.youtube.com/watch?v=6PWP1eZo53s
- https://doc.qt.io/qt-6/qserialport.html 


### Swift/Apple links
- https://developer.apple.com/documentation/iokit
- https://developer.apple.com/documentation/iokit/communicating_with_a_modem_on_a_serial_port
- https://developer.apple.com/documentation/driverkit
- if decide to use libusb: https://forums.swift.org/t/linking-to-c-libraries/55651/2
- https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/tcsetattr.3.html

### C/terminos links. 
- https://tldp.org/HOWTO/Serial-Programming-HOWTO/intro.html
- https://en.wikibooks.org/wiki/Serial_Programming/termios
- https://man7.org/linux/man-pages/man3/termios.3.html
- https://blog.nelhage.com/2009/12/a-brief-introduction-to-termios/
- http://unixwiz.net/techtips/termios-vmin-vtime.html
- talks about open()/fileDescriptors etc: https://www.youtube.com/watch?v=BQJBe4IbsvQ
- https://en.wikibooks.org/wiki/Serial_Programming/termios
- https://www.gnu.org/software/libc/manual/html_node/Setting-Modes.html
- https://stackoverflow.com/questions/31999358/how-are-flags-represented-in-the-termios-library
- https://circuitdigest.com/tutorial/serial-communication-protocols
- https://www.wevolver.com/article/baud-rates-the-most-common-baud-rates
- http://unixwiz.net/techtips/termios-vmin-vtime.html
- https://www.xanthium.in/Serial-Port-Programming-on-Linux

### Arduino
- https://www.arduino.cc/reference/en/language/functions/communication/serial/begin/
- https://chrisheydrick.com/2012/06/17/how-to-read-serial-data-from-an-arduino-in-linux-with-c-part-3/

