import SwiftSerialPort
import Foundation //for sleep


@main
struct CerealCLI {
    static func main() async throws {

        //let args = CommandLine.arguments
    let serialPort = try SerialPort(at:"/dev/cu.usbmodem1101")
    print(serialPort)
    sleep(3)
    let bytesWritten = try serialPort.write("A")
    print("\(bytesWritten)")
    // let incomingMessage = try serialPort.readAllAvailable()
    // print(incomingMessage, incomingMessage.count)

    // let incomingLine = try serialPort.readLines()
    // print(incomingLine)

    // let incomingMessage2 = serialPort.readUntil(oneOf: [30])
    // print("readUntil: \(incomingMessage2)")

    async let incomingMessage3 = serialPort.awaitData(count: 20)
    print("some other activities...")
    print("awaited: \(await incomingMessage3)")

    serialPort.close()
}
}