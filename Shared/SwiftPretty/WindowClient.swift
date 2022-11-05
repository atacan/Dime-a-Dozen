//
// https://github.com/atacan
// 05.11.22

import Cocoa
import Dependencies
import Foundation
import Highlight
import HighlightSwiftSyntax
import SwiftUI
import UniformTypeIdentifiers
import XCTestDynamicOverlay

struct WindowClient {
    var show: (any View) -> Void
}

extension DependencyValues {
    var windowClient: WindowClient {
        get { self[WindowClient.self] }
        set { self[WindowClient.self] = newValue }
    }
}

extension WindowClient: DependencyKey {
    static let liveValue = Self(
        show: { view in
            let height = 450.0
            let width = height * 1.618
            let window = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: width, height: height),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            window.center()
            window.isReleasedWhenClosed = false
            window.title = "Html Output"
            window.backgroundColor = .textBackgroundColor
            window.makeKeyAndOrderFront(nil)
            window.contentView = NSHostingView(rootView: AnyView(view))
        }
    )

    static let testValue = Self(
        show: unimplemented("\(Self.self).convert")
    )
}

extension View {
    private func newWindowInternal(with title: String) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 680, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.isReleasedWhenClosed = false
        window.title = title
        window.makeKeyAndOrderFront(nil)
        return window
    }

    func openNewWindow(with title: String = "new Window") {
        newWindowInternal(with: title).contentView = NSHostingView(rootView: self)
    }
}
