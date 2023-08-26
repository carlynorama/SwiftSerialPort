import Foundation
import SerialC

struct SerialPort {
    func openPort(at location:String) throws -> Int {
        try location.withCString { port_path in 
            let result = open_port(port_path)
            if result == -1 {
                throw SerialConnectionError.couldNotOpenPort
            } else {
                return Int(result)
            }
        }
        
    }
}

public enum SerialConnectionError:Error {
    case couldNotOpenPort
}