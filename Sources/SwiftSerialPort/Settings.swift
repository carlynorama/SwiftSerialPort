//
//  Settings.swift
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/27/23.
//
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

    //wait is in tenths of seconds
    //minNumberOfBytes should be lower than the bytes the read is requesting.
    //see http://unixwiz.net/techtips/termios-vmin-vtime.html
    public func setReadEscapes(wait vtime:UInt8, minNumberOfBytes vmin:UInt8) {
        set_early_fail_behavior(fileDescriptor, vtime, vmin)
    }


}