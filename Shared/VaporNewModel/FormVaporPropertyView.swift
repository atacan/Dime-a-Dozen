//
//  FormVaporPropertyView.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 11.06.22.
//

import SwiftUI

struct FormVaporPropertyView: View {
    @Binding var properties: [VaporProperty]

    var addNewButton: some View {
        Button {
            addNewProperty()
        } label: {
            Image(systemName: "plus")
        } // <-Button
    }
    
//    var myTable: some View {
//        Table($properties) {
//            TableColumn("Property Wrapper") { property in
//                FieldPropertyWrapperView(input: property.fluentPW)
//            }
//
//            TableColumn("Trigger") { property in
//                FieldTimestampTriggerView(input: property.fluentTimeTrigger)
//            }
//        }
//    }

    var myForm: some View {
        LazyVStack {
            ForEach($properties) { property in
                HStack(alignment: .center) {
                    InputVaporPropertyView(vaporProperty: property).equatable()
                    Button {
                        properties = properties.filter { $0.id != property.id}
                    } label: {
                        Image(systemName: "trash")
                    } // <-Button
                } // <-HStack
            } // <-ForEach
            addNewButton
        } // <-LazyVStack
    }
    
    var body: some View {
        myForm
//        myTable
    }

    func addNewProperty() {
        properties.append(VaporProperty(fluentPW: .field, name: "", fluentDataType: .string, isOptional: false, propertyType: VaporProperty.SwiftType.string.rawValue))
    }
}

// extension FormVaporPropertyView: Equatable {
//    static func == (lhs: FormVaporPropertyView, rhs: FormVaporPropertyView) -> Bool {
//        lhs.properties == lhs.properties
//    }
// }
