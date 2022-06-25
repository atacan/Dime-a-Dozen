//
//  LazyTextField.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 12.06.22.
//

import AppKit
import SwiftUI

struct LazyTextField: NSViewRepresentable {
    typealias NSViewType = NSTextField
    @Binding private var text: String
    var placeholderString: String
    var textCompletion = false
    var font = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.regular)
    
    init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholderString = placeholder
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.placeholderString = placeholderString
        setProperties(textField)
        textField.stringValue = text
        return textField
    }
    
    func setProperties(_ textField: NSTextField) {
        textField.isAutomaticTextCompletionEnabled = textCompletion
        textField.cell?.isScrollable = true
        textField.font = font
        textField.cell?.sendsActionOnEndEditing = true
        textField.allowsEditingTextAttributes = false
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
//        setProperties(nsView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: LazyTextField
        init(_ parent: LazyTextField) {
            self.parent = parent
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                parent.text = textField.stringValue
            }
        }
    }
}

extension LazyTextField  {
    public func fontFromNSFont(_ font: NSFont) -> LazyTextField {
        var view = self
        view.font = font
        return view
    }
}
