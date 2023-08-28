public enum SerialConnectionError:Error {
    case couldNotOpenPort
    case notADeviceFilePath
    case notARecognizedDeviceType
}

public enum SerialSettingsError:Error {
    case currentSettingsUnavailable
    case settingNotUpdated
    case notAValidBaudRate
}

public enum SerialCommunicationError:Error {
    case couldNotWrite
    case noBytesReceived
    case couldNotRead
}
