import SerialC

public enum ParityType {
    case none
    case even
    case odd

    var maskValue:CInt {
        switch self {
        case .none:
            return 0
        case .even:
            return PARENB
        case .odd:
            return PARENB | PARODD
        }
    }

    // var parityValue: tcflag_t {
    //     switch self {
    //     case .none:
    //         return 0
    //     case .even:
    //         return tcflag_t(PARENB)
    //     case .odd:
    //         return tcflag_t(PARENB | PARODD)
    //     }
    // }
}