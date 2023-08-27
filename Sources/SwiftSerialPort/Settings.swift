import SerialC

enum UpdateTiming {
    case immediate      //Make changes now without waiting for data to complete
    case beforeNext     //	Wait until everything has been transmitted
    case flushAndSet    //Flush input and output buffers and make the change
} 

//TODO: what is the size mask for this I wonder. 
extension UpdateTiming {
    var maskValue:Int32 {
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
    public func setBaudRate(_ newBaudRate:BaudRate) {
        let timing = UpdateTiming.immediate
        let r = update_baudrate(fileDescriptor, newBaudRate.maskValue, timing.maskValue)
        print(r)
    }
}
