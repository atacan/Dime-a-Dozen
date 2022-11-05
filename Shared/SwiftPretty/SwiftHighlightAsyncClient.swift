//
// https://github.com/atacan
// 20.10.22

import ComposableArchitecture
import Foundation
import Highlight
import HighlightSwiftSyntax
import SwiftFormat
import XCTestDynamicOverlay
import SwiftHtml
import Prelude

struct SwiftHighlightAsyncClient {
    var convert: @Sendable (String) async throws -> SwiftOutput
}

struct SwiftOutput: Equatable {
    let attributed: NSAttributedString
    let html: String
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
                    let highlighter = SwiftHighlighter(inputCode: pretty)
                    let highlighted = try highlighter.highlight()
                    let style = highlighter.styleContent()
                    let body = try highlighter.html()
                    let html = html(style: style, body: body)
                    return continuation.resume(returning: SwiftOutput(attributed: highlighted, html: html))
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

func html(style: String, body: String) -> String {
    Html {
        Head {
            Style(style)
        }
        Body {
            Text(body)
        }
    }
    |> render
}

private func render(_ tag: Tag) -> String {
    let doc = Document(.unspecified) { tag }
    return DocumentRenderer(minify: true, indent: 2).render(doc)
}
