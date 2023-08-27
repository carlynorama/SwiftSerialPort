

public enum SerialConnectionError:Error {
    case couldNotOpenPort
    case notADeviceFilePath
    case notARecognizedDeviceType
}

public enum SerialCommunicationError:Error {
    case couldNotWrite
    case noBytesReceived
    case couldNotRead
}