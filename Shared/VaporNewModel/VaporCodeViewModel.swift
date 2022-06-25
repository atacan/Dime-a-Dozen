//
//  VaporCodeViewModel.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 11.06.22.
//

import Combine

class VaporCodeViewModel: ObservableObject {
    var codeModelProperties: String = ""
    var codeModelFieldKeys: String = ""
    var codeModel: String = ""
    
    let caseConversion = CaseConversionViewModel()
    
    @Published var properties = [
        VaporProperty(fluentPW: .id, name: "id", fluentDataType: .uuid, isOptional: true, propertyType: VaporProperty.SwiftType.uuid.rawValue),
        VaporProperty(fluentPW: .timestamp, fluentTimeTrigger: VaporProperty.FluentTimestampTrigger.create, name: "createdAt", fluentDataType: .datetime, isOptional: true, propertyType: VaporProperty.SwiftType.date.rawValue),
        VaporProperty(fluentPW: .timestamp, fluentTimeTrigger: VaporProperty.FluentTimestampTrigger.update, name: "updatedAt", fluentDataType: .datetime, isOptional: true, propertyType: VaporProperty.SwiftType.date.rawValue),
    ]

    var cancellables: Set<AnyCancellable> = []

    func temporaryOutput() -> String {
        properties.map { p -> String in
            String(describing: p)
        }
        .joined(separator: "\n\n")
    }
    
    func generateModelCode() -> String {
        // read Model template file
        // if it has Field Keys section
        generateModelFieldKeys() + "\n\n" + generateModelProperties()
    }

    func generateModelProperties() -> String {
        codeModelProperties = ""
        codeModelProperties = properties.map { property -> String in
            switch property.fluentPW {
            case .field:
                // @Field(key: FieldKeys.image) var image: String
                return "@Field(key: FieldKeys.\(property.name)) var \(property.name): \(property.propertyType)\(property.optionalSuffix)"
            case .timestamp:
                // @Timestamp(key: FieldKeys.createdAt, on: .create) var createdAt: Date?
                return "@Timestamp(key: FieldKeys.\(property.name), on \(property.fluentTimeTrigger?.rawValue ?? ".none") var \(property.name): \(property.propertyType)\(property.optionalSuffix)"
            default:
                return ""
            }
        }
        .joined(separator: "\n")

        return codeModelProperties
    }
    
    func generateModelFieldKeys() -> String {
        codeModelFieldKeys = ""
        codeModelFieldKeys = properties.map { property -> String in
            let snakeName = caseConversion.convert(inputText: property.name, from: .camel, to: .snake)
//            static var image: FieldKey { "image" }
            return "static var \(property.name): FieldKey { \"\(snakeName)\" }"
        }
        .joined(separator: "\n")
        
        return codeModelFieldKeys
    }
}
