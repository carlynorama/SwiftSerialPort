import SerialC



// c_cflag	Control options
// c_lflag	Line options
// c_iflag	Input options
// c_oflag	Output options
// c_cc	Control characters
// c_ispeed	Input baud (new interface)
// c_ospeed	Output baud (new interface)


enum UpdateTiming {
    case immediate      //Make changes now without waiting for data to complete
    case beforeNext     //Wait until everything has been transmitted, make the change
    case flushAndSet    //Finish sending output, flush input, make the change
    //TODO: MISSING TCSASOFT
} 

//TODO: what is the size mask for this I wonder. 
extension UpdateTiming {
    var maskValue:CInt {
        switch self {
        case .immediate:
            return TCSANOW
        case .beforeNext:
            return TCSADRAIN
        case .flushAndSet:
            return TCSAFLUSH
        }
    }
}

extension SerialPort {
    //Tested. Works.
    public func setBaudRate(_ newBaudRate:BaudRate) {
        let timing = UpdateTiming.immediate
        let r = update_baudrate(fileDescriptor, newBaudRate.maskValue, timing.maskValue)
        print(r)
    }

    //Only semi tested.
    public func updateBasicSettings(bitSize:DataBitsSize, parity:ParityType, useSecondStopBit:Bool) {
        let timing = UpdateTiming.immediate
        
        // Set up the control structure
        var settings = termios()
        // Get options structure for the port
        var r = tcgetattr(fileDescriptor, &settings)
        //if (r < 0) { throw }
        print("settings:\(settings)")
        // Enable parity (even/odd) if needed
        settings.c_cflag |= tcflag_t(parity.maskValue)

        // Set stop bit flag
        if useSecondStopBit {
            settings.c_cflag |= tcflag_t(CSTOPB)
        } else {
            settings.c_cflag &= ~tcflag_t(CSTOPB)
        }

        // Set data bits size flag
        settings.c_cflag &= ~tcflag_t(CSIZE)
        settings.c_cflag |= tcflag_t(bitSize.maskValue)


        tcsetattr(fileDescriptor, timing.maskValue, &settings)

    }

}



//            //Disable input mapping of CR to NL, mapping of NL into CR, and ignoring CR
//            settings.c_iflag &= ~tcflag_t(ICRNL | INLCR | IGNCR)
//
//            // Set hardware flow control flag
//        #if os(Linux)
//            if useHardwareFlowControl {
//                settings.c_cflag |= tcflag_t(CRTSCTS)
//            } else {
//                settings.c_cflag &= ~tcflag_t(CRTSCTS)
//            }
//        #elseif os(OSX)
//            if useHardwareFlowControl {
//                settings.c_cflag |= tcflag_t(CRTS_IFLOW)
//                settings.c_cflag |= tcflag_t(CCTS_OFLOW)
//            } else {
//                settings.c_cflag &= ~tcflag_t(CRTS_IFLOW)
//                settings.c_cflag &= ~tcflag_t(CCTS_OFLOW)
//            }
//        #endif
//
//            // Set software flow control flags
//            let softwareFlowControlFlags = tcflag_t(IXON | IXOFF | IXANY)
//            if useSoftwareFlowControl {
//                settings.c_iflag |= softwareFlowControlFlags
//            } else {
//                settings.c_iflag &= ~softwareFlowControlFlags
//            }
//
//            // Turn on the receiver of the serial port, and ignore modem control lines
//            settings.c_cflag |= tcflag_t(CREAD | CLOCAL)
//
//            // Turn off canonical mode
//            settings.c_lflag &= ~tcflag_t(ICANON | ECHO | ECHOE | ISIG)
//
//            // Set output processing flag
//            if processOutput {
//                settings.c_oflag |= tcflag_t(OPOST)
//            } else {
//                settings.c_oflag &= ~tcflag_t(OPOST)
//            }
//
//            //Special characters
//            //We do this as c_cc is a C-fixed array which is imported as a tuple in Swift.
//            //To avoid hardcoding the VMIN or VTIME value to access the tuple value, we use the typealias instead
//        #if os(Linux)
//            typealias specialCharactersTuple = (VINTR: cc_t, VQUIT: cc_t, VERASE: cc_t, VKILL: cc_t, VEOF: cc_t, VTIME: cc_t, VMIN: cc_t, VSWTC: cc_t, VSTART: cc_t, VSTOP: cc_t, VSUSP: cc_t, VEOL: cc_t, VREPRINT: cc_t, VDISCARD: cc_t, VWERASE: cc_t, VLNEXT: cc_t, VEOL2: cc_t, spare1: cc_t, spare2: cc_t, spare3: cc_t, spare4: cc_t, spare5: cc_t, spare6: cc_t, spare7: cc_t, spare8: cc_t, spare9: cc_t, spare10: cc_t, spare11: cc_t, spare12: cc_t, spare13: cc_t, spare14: cc_t, spare15: cc_t)
//            var specialCharacters: specialCharactersTuple = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) // NCCS = 32
//        #elseif os(OSX)
//            typealias specialCharactersTuple = (VEOF: cc_t, VEOL: cc_t, VEOL2: cc_t, VERASE: cc_t, VWERASE: cc_t, VKILL: cc_t, VREPRINT: cc_t, spare1: cc_t, VINTR: cc_t, VQUIT: cc_t, VSUSP: cc_t, VDSUSP: cc_t, VSTART: cc_t, VSTOP: cc_t, VLNEXT: cc_t, VDISCARD: cc_t, VMIN: cc_t, VTIME: cc_t, VSTATUS: cc_t, spare: cc_t)
//            var specialCharacters: specialCharactersTuple = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) // NCCS = 20
//        #endif
//
//            specialCharacters.VMIN = cc_t(minimumBytesToRead)
//            specialCharacters.VTIME = cc_t(timeout)
//            settings.c_cc = specialCharacters
//
//            // Commit settings
