//
//  Extensions.swift
//  DimeADozen
//
//  Created by atacan on 11.06.22.
//

import SwiftUI

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}

func standardNSAttributed(_ input: String) -> NSMutableAttributedString {
    NSMutableAttributedString(string: input,
                              attributes: [.font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.regular),
                                           .foregroundColor: NSColor.textColor])
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

extension String {
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropFirst(suffix.count))
    }
}
