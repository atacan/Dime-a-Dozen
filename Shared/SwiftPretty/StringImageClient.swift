//
// https://github.com/atacan
// 05.11.22

import Cocoa
import Dependencies
import Foundation
import Highlight
import HighlightSwiftSyntax
import UniformTypeIdentifiers
import XCTestDynamicOverlay

extension NSGraphicsContext {
    func fill(with color: NSColor, in rect: CGRect) {
        cgContext.setFillColor(color.cgColor)
        cgContext.fill(rect)
    }
}

extension NSGraphicsContext {
    convenience init(size: CGSize) {
        let scale: CGFloat = 2

        let context = CGContext(
            data: nil,
            width: Int(size.width * scale),
            height: Int(size.height * scale),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )!

        context.scaleBy(x: scale, y: scale)

        self.init(cgContext: context, flipped: false)
    }
}

extension CGImage {
    func write(to url: URL) {
//        CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)
        let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
        CGImageDestinationAddImage(destination, self, nil)
        CGImageDestinationFinalize(destination)
    }
}

func image(for string: NSMutableAttributedString) -> CGImage {
    let stringSize = string.size()
    let padding = CGFloat(8)

    let contextRect = CGRect(
        x: 0,
        y: 0,
        width: stringSize.width + padding * 4,
        height: stringSize.height + padding * 4
    )

    let context = NSGraphicsContext(size: contextRect.size)
    NSGraphicsContext.current = context

    context.fill(with: NSColor.black, in: contextRect)

    string.draw(in: CGRect(
        x: padding * 2,
        y: padding * 2,
        width: stringSize.width,
        height: stringSize.height
    ))

    let image = context.cgContext.makeImage()!
    return image
}

@MainActor
func saveImage(_ image: CGImage) {
    let openPanel = NSOpenPanel()
    openPanel.prompt = "Select"
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = true
    openPanel.canChooseFiles = false
    openPanel.begin { result in
        if result.rawValue == NSApplication.ModalResponse.OK.rawValue,
           let selectedUrl = openPanel.url
        {
            let imageUrl = selectedUrl.appendingPathComponent("\(UUID()).png")
//            let imageUrl = selectedUrl.appendingPathComponent("test.png")
            image.write(to: imageUrl)
        }
    }
}

struct StringImageClient {
    var save: @Sendable (NSMutableAttributedString) async -> Void
}

extension DependencyValues {
    var stringImageClient: StringImageClient {
        get { self[StringImageClient.self] }
        set { self[StringImageClient.self] = newValue }
    }
}

extension StringImageClient: DependencyKey {
    static let liveValue = Self(
        save: { input in
            let image = image(for: input)
            return await saveImage(image)
        }
    )

    static let testValue = Self(
        save: unimplemented("\(Self.self).convert")
    )
}
