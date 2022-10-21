//
// https://github.com/atacan
// 21.10.22

import ComposableArchitecture
import Foundation
import Cocoa

struct CopyClient {
    var copyToClipboard: (NSAttributedString) -> Void
}

extension DependencyValues {
    var copyClient: CopyClient {
        get { self[CopyClient.self] }
        set { self[CopyClient.self] = newValue }
    }
}

extension CopyClient: DependencyKey {
    static var liveValue: CopyClient = Self(
        copyToClipboard: { nsAttrString in
            NSPasteboard.general.clearContents()
            NSPasteboard.general.writeObjects([nsAttrString])
        }
    )
}
