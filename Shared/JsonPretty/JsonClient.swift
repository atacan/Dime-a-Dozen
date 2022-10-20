//
// https://github.com/atacan
// 20.10.22

import ComposableArchitecture
import Foundation
import Highlight
import XCTestDynamicOverlay

struct JsonClient {
    var convert: @Sendable (String) async throws -> NSAttributedString
}

enum JsonClientError: Error {
    case jsonSerial
    case stringEncoding
}

extension JsonClientError: LocalizedError  {
    var errorDescription: String? {
        switch self {
        case .jsonSerial:
            return "JSONSerialization"
        case .stringEncoding:
            return "this didn't work `jsonString = String(data: data, encoding: .utf8)` "
        }
    }
}

extension DependencyValues {
    var jsonClient: JsonClient {
        get { self[JsonClient.self] }
        set { self[JsonClient.self] = newValue }
    }
}

extension JsonClient: DependencyKey {
    static let liveValue = Self(
        convert: { input in
            try await withCheckedThrowingContinuation { continuation in
                do {
                    let json = try JSONSerialization.jsonObject(with: Data(input.utf8), options: [])
                    let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    
                    guard let jsonString = String(data: data, encoding: .utf8) else {
                        return continuation.resume(throwing: JsonClientError.stringEncoding)
                    }
                    
                    let highlighted = JsonSyntaxHighlightProvider.shared.highlight(jsonString, as: .json)
                    return continuation.resume(returning: highlighted)
                } catch {
                    return continuation.resume(throwing: error)
                }
            }
        }
    )

    static let testValue = Self(
        convert: unimplemented("\(Self.self).convert")
    )
}
