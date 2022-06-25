//
//  ViewComponents.swift
//  DimeADozen
//
//  https://stackoverflow.com/questions/67956554/how-to-get-a-combobox-with-swiftui
//  https://stackoverflow.com/questions/67190696/what-wiring-code-is-necessary-to-wrap-nscombobox-with-nsviewrepresentable

import SwiftUI

struct VDKComboBox: NSViewRepresentable
{
    // The items that will show up in the pop-up menu:
    var items: [String]
    
    // The property on our parent view that gets synced to the current stringValue of the NSComboBox, whether the user typed it in or selected it from the list:
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSComboBox
    {
        let comboBox = NSComboBox()
        comboBox.usesDataSource = false
        comboBox.completes = false
        comboBox.delegate = context.coordinator
        comboBox.intercellSpacing = NSSize(width: 0.0, height: 10.0) // Matches the look and feel of Big Sur onwards.
        return comboBox
    }
    
    func updateNSView(_ nsView: NSComboBox, context: Context)
    {
        nsView.removeAllItems()
        nsView.addItems(withObjectValues: items)
        
        // ComboBox doesn't automatically select the item matching its text; we must do that manually. But we need the delegate to ignore that selection-change or we'll get a "state modified during view update; will cause undefined behavior" warning.
        context.coordinator.ignoreSelectionChanges = true
        nsView.stringValue = text
        nsView.selectItem(withObjectValue: text)
        context.coordinator.ignoreSelectionChanges = false
    }
}

// MARK: - Coordinator

extension VDKComboBox
{
    class Coordinator: NSObject, NSComboBoxDelegate
    {
        var parent: VDKComboBox
        var ignoreSelectionChanges: Bool = false
        
        init(_ parent: VDKComboBox)
        {
            self.parent = parent
        }
        
        func comboBoxSelectionDidChange(_ notification: Notification)
        {
            if !ignoreSelectionChanges,
               let box: NSComboBox = notification.object as? NSComboBox,
               let newStringValue: String = box.objectValueOfSelectedItem as? String
            {
                parent.text = newStringValue
            }
        }
        
        func controlTextDidEndEditing(_ obj: Notification)
        {
            if let textField = obj.object as? NSTextField
            {
                parent.text = textField.stringValue
            }
        }
    }
}
