//
// https://github.com/atacan
// 20.10.22

import ComposableArchitecture
import Foundation
import Highlight
import HighlightSwiftSyntax
import SwiftFormat
import XCTestDynamicOverlay

struct SwiftHighlightAsyncClient {
    var convert: @Sendable (String) async throws -> NSAttributedString
}

extension DependencyValues {
    var swiftHighlightAsyncClient: SwiftHighlightAsyncClient {
        get { self[SwiftHighlightAsyncClient.self] }
        set { self[SwiftHighlightAsyncClient.self] = newValue }
    }
}

extension SwiftHighlightAsyncClient: DependencyKey {
    static let liveValue = Self(
        convert: { input in
            try await withCheckedThrowingContinuation { continuation in
                do {
                    let pretty = try SwiftFormat.format(input,
                                                        rules: FormatRules.all(except: ["linebreakAtEndOfFile"]),
                                                        options: FormatOptions(
                                                            wrapArguments: .beforeFirst,
                                                            wrapCollections: .beforeFirst
                                                        ),
                                                        lineRange: nil)
                    let highlighted = try SwiftHighlighter(inputCode: pretty).highlight()
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
