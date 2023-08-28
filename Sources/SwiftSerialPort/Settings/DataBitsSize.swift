import SerialC

public enum DataBitsSize {
    case bits5
    case bits6
    case bits7
    case bits8

    var maskValue:CInt {
        switch self {
        case .bits5:
            return CS5
        case .bits6:
            return CS6
        case .bits7:
            return CS7
        case .bits8:
            return CS8
}
    }

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

}