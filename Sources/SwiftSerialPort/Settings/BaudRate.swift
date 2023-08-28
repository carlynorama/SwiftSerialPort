import SerialC

//TODO: SwiftSerial used speed_t, but that didn't work for me. 

#if os(Linux)
public enum BaudRate {
    case baud0
    case baud50
    case baud75
    case baud110
    case baud134
    case baud150
    case baud200
    case baud300
    case baud600
    case baud1200
    case baud1800
    case baud2400
    case baud4800
    case baud9600
    case baud19200
    case baud38400
    case baud57600
    case baud115200
    case baud230400
    case baud460800
    case baud500000
    case baud576000
    case baud921600
    case baud1000000
    case baud1152000
    case baud1500000
    case baud2000000
    case baud2500000
    case baud3500000
    case baud4000000

    var maskValue: CInt {
        switch self {
        case .baud0:
            return  B0
        case .baud50:
            return  B50
        case .baud75:
            return  B75
        case .baud110:
            return  B110
        case .baud134:
            return  B134
        case .baud150:
            return  B150
        case .baud200:
            return  B200
        case .baud300:
            return  B300
        case .baud600:
            return  B600
        case .baud1200:
            return  B1200
        case .baud1800:
            return  B1800
        case .baud2400:
            return  B2400
        case .baud4800:
            return  B4800
        case .baud9600:
            return  B9600
        case .baud19200:
            return  B19200
        case .baud38400:
            return  B38400
        case .baud57600:
            return  B57600
        case .baud115200:
            return  B115200
        case .baud230400:
            return  B230400
        case .baud460800:
            return  B460800
        case .baud500000:
            return  B500000
        case .baud576000:
            return  B576000
        case .baud921600:
            return  B921600
        case .baud1000000:
            return  B1000000
        case .baud1152000:
            return  B1152000
        case .baud1500000:
            return  B1500000
        case .baud2000000:
            return  B2000000
        case .baud2500000:
            return  B2500000
        case .baud3500000:
            return  B3500000
        case .baud4000000:
            return  B4000000
        }
    }
}
#elseif os(OSX)
public enum BaudRate {
    case baud0
    case baud50
    case baud75
    case baud110
    case baud134
    case baud150
    case baud200
    case baud300
    case baud600
    case baud1200
    case baud1800
    case baud2400
    case baud4800
    case baud9600
    case baud19200
    case baud38400
    case baud57600
    case baud115200
    case baud230400

    var maskValue: CInt {
        switch self {
        case .baud0:
            return  B0
        case .baud50:
            return  B50
        case .baud75:
            return  B75
        case .baud110:
            return  B110
        case .baud134:
            return  B134
        case .baud150:
            return  B150
        case .baud200:
            return  B200
        case .baud300:
            return  B300
        case .baud600:
            return  B600
        case .baud1200:
            return  B1200
        case .baud1800:
            return  B1800
        case .baud2400:
            return  B2400
        case .baud4800:
            return  B4800
        case .baud9600:
            return  B9600
        case .baud19200:
            return  B19200
        case .baud38400:
            return  B38400
        case .baud57600:
            return  B57600
        case .baud115200:
            return  B115200
        case .baud230400:
            return  B230400
        }
    }
}
#endif
