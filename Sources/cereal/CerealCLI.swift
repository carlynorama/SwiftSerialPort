//
//  CerealCLI.swift
//  SwiftSerialPort
//
//  Created by Carlyn Maw on 8/26/23.
//


import SwiftSerialPort
import SerialC //lets me call sleep without importing Foundation.


@main
struct CerealCLI {
    static func main() async throws {

        //let args = CommandLine.arguments
    let serialPort = try SerialPort(at:"/dev/cu.usbmodem1101")
    try serialPort.setBaudRate(57600)
    serialPort.flush() //will mess with async calls.
    print(serialPort)
    sleep(3)
    let bytesWritten = try serialPort.write("A")
    print("\(bytesWritten)")
    let incomingMessage = try serialPort.readAllAvailable()
    print(incomingMessage, incomingMessage.count)
    sleep(2)
    // let incomingLine = try serialPort.readLines()
    // print(incomingLine)

    let incomingMessage2 = serialPort.readUntil(oneOf: [30, 63])
    print("readUntil: \(incomingMessage2)")
    //serialPort.flush()
    async let incomingMessage3 = serialPort.awaitData(count: 20)
    print("some other activities...")
    print("awaited: \(await incomingMessage3)")

    serialPort.close()
}
}
