// https://github.com/atacan/
// 29.05.22
//

import Foundation

// Example usage:
// do {
//    safeShell("ls -la")
// }
// catch {
//    print("\(error)") // handle or silence the error here
// }
func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") // <--updated
    task.standardInput = nil

    try task.run() // <--updated

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}
