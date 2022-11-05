//
// https://github.com/atacan
// 05.11.22

import Dependencies
import Foundation
import Highlight
import XCTestDynamicOverlay
import HighlightSwiftSyntax

struct SwiftHighlightClient {
    var convert: (String) throws -> NSAttributedString
}

//enum SwiftHighlightClientError: Error {
//    case jsonSerial
//    case stringEncoding
//}

//extension SwiftHighlightClientError: LocalizedError  {
//    var errorDescription: String? {
//        switch self {
//        case .jsonSerial:
//            return "JSONSerialization"
//        case .stringEncoding:
//            return "this didn't work `jsonString = String(data: data, encoding: .utf8)` "
//        }
//    }
//}

extension DependencyValues {
    var swiftHighlightClient: SwiftHighlightClient {
        get { self[SwiftHighlightClient.self] }
        set { self[SwiftHighlightClient.self] = newValue }
    }
}

extension SwiftHighlightClient: DependencyKey {
    static let liveValue = Self(
        convert: { input in
            try SwiftHighlighter.init(inputCode: input).highlight()
        }
    )

    static let testValue = Self(
        convert: unimplemented("\(Self.self).convert")
    )
}
