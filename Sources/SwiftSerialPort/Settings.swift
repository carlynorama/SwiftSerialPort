import SerialC

// FROM termios.h

// typedef unsigned long   tcflag_t;
// typedef unsigned char   cc_t;
// typedef unsigned long   speed_t;

// struct termios {
// 	tcflag_t        c_iflag;        /* input flags */
// 	tcflag_t        c_oflag;        /* output flags */
// 	tcflag_t        c_cflag;        /* control flags */
// 	tcflag_t        c_lflag;        /* local flags */
// 	cc_t            c_cc[NCCS];     /* control chars */
// 	speed_t         c_ispeed;       /* input speed */
// 	speed_t         c_ospeed;       /* output speed */
// };


enum UpdateTiming {
    case immediate      //Make changes now without waiting for data to complete
    case beforeNext     //Wait until everything has been transmitted, make the change
    case flushAndSet    //Finish sending output, flush input, make the change
} 

//TODO: feels fragile doing this across the boundary
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
        //TODO: MISSING TCSASOFT
    }
}

extension SerialPort {
    //Tested. Works.
    //TODO: Allow for arbitrary input? Like todbot serial? Verification on the C side.
    public func setBaudRate(_ newBaudRate:CInt) throws {
        let timing = UpdateTiming.immediate
        var validated:speed_t = 0
        var warning = validate_baudrate(newBaudRate, &validated)
        if warning < 0 {
            print("Non-standard baud rate warning: \(newBaudRate) isn't on the standard list")
            throw SerialSettingsError.notAValidBaudRate
        }
        warning = update_baudrate(fileDescriptor, validated, timing.maskValue)
        if warning == -2 {
            throw SerialSettingsError.settingNotUpdated
        } else if warning == -1 {
            throw SerialSettingsError.currentSettingsUnavailable
        }
    }

}


    //Only semi tested. 8N1 is fine for me for now.
    //Would prefer to do this in the C lib
    // public func updateBasicSettings(bitSize:DataBitsSize, parity:ParityType, useSecondStopBit:Bool) {
    //     let timing = UpdateTiming.immediate
        
    //     // Set up the control structure
    //     var settings = termios()
    //     // Get options structure for the port
    //     var r = tcgetattr(fileDescriptor, &settings)
    //     //if (r < 0) { throw }
    //     print("settings:\(settings)")
    //     // Enable parity (even/odd) if needed
    //     settings.c_cflag |= tcflag_t(parity.maskValue)

    //     // Set stop bit flag
    //     if useSecondStopBit {
    //         settings.c_cflag |= tcflag_t(CSTOPB)
    //     } else {
    //         settings.c_cflag &= ~tcflag_t(CSTOPB)
    //     }

    //     // Set data bits size flag
    //     settings.c_cflag &= ~tcflag_t(CSIZE)
    //     settings.c_cflag |= tcflag_t(bitSize.maskValue)


    //     tcsetattr(fileDescriptor, timing.maskValue, &settings)

    // }

//Do not like that defines get stored as CINTs when they will be needed as tcflag_t. Only use the defines in C.

//public enum ParityType {
//    case none
//    case even
//    case odd
//
//    var maskValue:CInt {
//        switch self {
//        case .none:
//            return 0
//        case .even:
//            return PARENB
//        case .odd:
//            return PARENB | PARODD
//        }
//    }
//
//    // var parityValue: tcflag_t {
//    //     switch self {
//    //     case .none:
//    //         return 0
//    //     case .even:
//    //         return tcflag_t(PARENB)
//    //     case .odd:
//    //         return tcflag_t(PARENB | PARODD)
//    //     }
//    // }
//}
//
//import SerialC
//
//public enum DataBitsSize {
//    case bits5
//    case bits6
//    case bits7
//    case bits8
//
//    var maskValue:CInt {
//        switch self {
//        case .bits5:
//            return CS5
//        case .bits6:
//            return CS6
//        case .bits7:
//            return CS7
//        case .bits8:
//            return CS8
//}
//    }
//
//    
    // var flagValue: tcflag_t {
    //     switch self {
    //     case .bits5:
    //         return tcflag_t(CS5)
    //     case .bits6:
    //         return tcflag_t(CS6)
    //     case .bits7:
    //         return tcflag_t(CS7)
    //     case .bits8:
    //         return tcflag_t(CS8)
    //     }
    // }

//}

//

