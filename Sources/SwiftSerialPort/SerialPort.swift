//
//  SerialPort.swift
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.

import SerialC

public final class SerialPort {
    let fileDescriptor:Int32
    public let devicePath:String
    
    var description:String {
        "fileDescriptor: \(fileDescriptor)"
    }
    
    public init(at location:String, withPathValidation:Bool = true) throws {
        self.fileDescriptor = try Self.openPort(at: location)
        if withPathValidation {
            self.devicePath = try Self.validatedDevicePath(location)
        } else {
            self.devicePath = location
        }
    }
    
    //TODO: Too opinionated? 
    public static func validatedDevicePath(_ path:String) throws -> String {
        guard path.prefix(5) == "/dev/" else {
            throw SerialConnectionError.notADeviceFilePath
        }
        
        //TODO: Requires macOS 13.... will work on Linux?
        //TODO: does it have to be .modem as well for now? 
        guard path.contains("cu") || path.contains("tty") else {
            throw SerialConnectionError.notARecognizedDeviceType
        }
        return path
    }
    
    public static func openPort(at location:String) throws -> Int32 {
        try location.withCString { port_path in 
            let result = open_port(port_path)
            if result == -1 {
                throw SerialConnectionError.couldNotOpenPort
            } else {
                return result
            }
        }  
    }

    deinit {
        close()
    }
    
    func close() {
        let result = close_port(fileDescriptor)
        print("closing \(fileDescriptor): \(result)")
    }

    public func flush() {
        let result = flush_port(fileDescriptor)
        print ("flushing \(fileDescriptor): \(result)")
    }
    
}

//MARK: Transmit
extension SerialPort {
    
    public func write<T>(_ outBytes:T) throws -> Int {
        return try withUnsafeBytes(of: outBytes) { message in 
            let r = write_to_port(fileDescriptor, message.baseAddress, message.count)
            if r == -1 {
                throw SerialCommunicationError.couldNotWrite
            }
            return r
        }
    }
}

//MARK: Receive
extension SerialPort {
    
    // TODO: Try to cast as type like with JSON? 
    // public func read<T>(count:Int, of type:T.Type) throws -> [T] {
    //     withUnsafeTemporaryAllocation(of: type, capacity: count) { buffer_pointer in 
    //     }
    // }
    
    public func readIfAvailable(maxCount:Int) throws -> [UInt8] {
        var dataBuffer = Array<UInt8>(repeating: 0, count: maxCount)
        let bytesReceived = dataBuffer.withUnsafeMutableBufferPointer { bufferPointer in
            return noblock_read_from_port(fileDescriptor, bufferPointer.baseAddress, maxCount)
        }
        if bytesReceived == 0 {
            throw SerialCommunicationError.noBytesReceived
        } else if bytesReceived < 0 {
            throw SerialCommunicationError.couldNotRead
        }
        return Array(dataBuffer.prefix(bytesReceived))
    }
    
    public func bytesAvailable() -> Int {
        var byteCount:Int32 = 0;
        //TODO: Catch error? 
        let error = bytes_available(fileDescriptor, &byteCount)
        if error != 0 {
            
        }
        return Int(byteCount)
    }
    
    public func readAllAvailable() throws -> [UInt8] {
        var byteCount:Int32 = 0;
        let _ = bytes_available(fileDescriptor, &byteCount)
        if byteCount > 0 {
            return try readIfAvailable(maxCount: Int(byteCount))
        } else {
            return []
        }
    }
    
    public func readAvailableLines(maxLength:Int = 1024) throws -> (lines:[String], remainder:String) {
        var buffer = try readAllAvailable()
        //TODO: other encodings aren't likely but aren't impossible. 
        buffer.append(0) //cString must be null terminated 
        var dataAsString = String(cString: buffer)
        var remainder:String
        if let lastNewLine =  dataAsString.lastIndex(where: { $0.isNewline }) {
            remainder = String(dataAsString[lastNewLine...].trimmingPrefix(while: { $0.isNewline }))
            dataAsString.removeSubrange(lastNewLine...)
        } else {
            remainder = ""
        }
        let lines = dataAsString.split(maxSplits: maxLength, omittingEmptySubsequences: true, whereSeparator: { $0.isNewline }).map { String($0) }
        print(lines)
        return (lines, remainder)
    }
    
    //This will be _much_ slower than using readAllAvailable and parsing the buffer
    //as needed in your own code. Offered as a convenience. 
    public func readUntil(oneOf:[UInt8], orMaxCount maxCount:Int = 256, tries:Int = 3) -> [UInt8] {
        var message:[UInt8] = []
        var currentTry = 0
        var bytesReceived = 1
        
        let filler:UInt8 = oneOf.contains(0) ? 255 : 0
        
        while bytesReceived == 1 {
            var dataBuffer = Array<UInt8>(repeating: filler, count: 1)
            bytesReceived = dataBuffer.withUnsafeMutableBufferPointer { bufferPointer in
                return noblock_read_from_port(fileDescriptor, bufferPointer.baseAddress, 1)
            }
            
            switch bytesReceived {
            case 1:
                if !oneOf.contains(dataBuffer[0]) {
                    message.append(dataBuffer[0])
                    if message.count == maxCount { return message }
                } else {
                    return message
                }
            default:
                print("readUntil bytesReceived: \(bytesReceived)")
                if currentTry < tries {
                    currentTry += 1
                    bytesReceived = 1
                }
            }
        }
        return message
    }
    
    //TODO: how to make cancellable? Rely on port settings?
    public func awaitBytes(count:Int) async -> Result<[UInt8], Error> {
        var dataBuffer = Array<UInt8>(repeating: 0, count: count)
        let bytesReceived = dataBuffer.withUnsafeMutableBufferPointer { bufferPointer in
            return default_read_from_port(fileDescriptor, bufferPointer.baseAddress, count)
        }
        if bytesReceived == 0 {
            //Depends on port settings if this is possible
            return .failure(SerialCommunicationError.noBytesReceived)
        } else if bytesReceived < 0 {
            return .failure(SerialCommunicationError.couldNotRead)
        }
        return .success(Array(dataBuffer.prefix(bytesReceived)))
    }
    

} 
