//
//  InputVaporPropertyView.swift
//  DimeADozen (iOS)
//
//  Created by atacan on 11.06.22.
//

import SwiftUI

struct InputVaporPropertyView: View {
    @Binding var vaporProperty: VaporProperty

    var body: some View {
        HStack(alignment: .center) {
            Picker("", selection: $vaporProperty.fluentPW) {
                ForEach(VaporProperty.FluentPropertyWrapper.allCases) { fluent in
                    Text(fluent.rawValue)
                        .font(.monospaced(.body)())
                }
            }
            .help("Fluent Property Wrapper")

            if vaporProperty.fluentPW == .timestamp {
                Picker("on", selection: $vaporProperty.fluentTimeTrigger) {
                    ForEach(VaporProperty.FluentTimestampTrigger.allCases) { trigger in
                        Text(trigger.rawValue)
                            .font(.monospaced(.body)())
                            .tag(Optional(trigger))
                    }
                }
                .help("timestamp trigger")
            }

            if vaporProperty.fluentPW == .children {
                HStack {
                    Text("for")
                    LazyTextField(text: Binding($vaporProperty.childrenKeyPath, replacingNilWith: #"\.$"#), placeholder: "child key path")
                }
                .help("key path to the child's property")
            }

            LazyTextField(text: $vaporProperty.name, placeholder: "Property name")
                .help("Name of the property")

            Picker("", selection: $vaporProperty.fluentDataType) {
                ForEach(VaporProperty.FluentDataType.allCases) { dataType in
                    Text(dataType.rawValue)
                        .font(.monospaced(.body)())
                }
            }

            VDKComboBox(items: VaporProperty.SwiftType.allCases.map { type in
                type.rawValue
            }, text: $vaporProperty.propertyType)
                .help("Select a standard Swift type or input a custom type")

            Toggle("?", isOn: $vaporProperty.isOptional)
                .help("Check if the type is Optional")
        } // <-HStack
        .id(vaporProperty.id)
    }
}

extension InputVaporPropertyView: Equatable {
    static func == (lhs: InputVaporPropertyView, rhs: InputVaporPropertyView) -> Bool {
        // return yes on view properties which identifies that the view is equal and should not be refreshed (ie. `body` is not rebuilt)
        lhs.vaporProperty == rhs.vaporProperty
    }
}
