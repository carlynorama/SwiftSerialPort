// The Swift Programming Language
// https://docs.swift.org/swift-book

import SerialC

struct SerialPort {
    func provideInt() -> Int {
        return Int(return_an_int())
    }
}