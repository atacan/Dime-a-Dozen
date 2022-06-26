//
//  VaporCodeViewModel.swift
//  DimeADozen
//
//  Created by atacan on 11.06.22.
//

import Combine
import Foundation
import SwiftFormat

private extension String {
    func swiftFormat() -> String {
        do {
            return try format(self)
        } catch {
            print(error)
            return self
        }
    }
}

class VaporCodeViewModel: ObservableObject {
    @Published var modelName: String = ""
    var vaporModel: VaporModel = .init(name: "")
    var codeModelProperties: String = ""
    var codeMigrationProperties: String = ""
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

    func createModel() {
        vaporModel = VaporModel(name: modelName)
    }

    func readTemplateFile(name: String) -> String? {
        if let templateFileURL = Bundle.main.url(forResource: name, withExtension: "txt") {
            do {
                let templateContent = try String(contentsOf: templateFileURL)
                let output = templateContent
                    .replacingOccurrences(of: "___VARIABLE_ModelNameUpper___", with: vaporModel.name)
                    .replacingOccurrences(of: "___VARIABLE_ModelNameLower___", with: vaporModel.nameLower)
                    .replacingOccurrences(of: "___VARIABLE_ModelNamePlural___", with: vaporModel.nameLowerPlural)
                return output
            } catch {
                print(error)
                return nil
            }
        } else {
            print("template file not found")
            return nil
        }
    }
    
    func generateModelCode() -> String {
        // read Model template file
        let fieldKeys =  generateModelFieldKeys()
        let modelProperties = generateModelProperties()
        if let template = readTemplateFile(name: "TemplateModel") {
            return template
                .replacingOccurrences(of: "___VARIABLE_PropertiesFieldKeys___", with: fieldKeys)
                .replacingOccurrences(of: "___VARIABLE_Properties___", with: modelProperties)
                .swiftFormat()
        }
        return fieldKeys + "\n\n" + modelProperties
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
                return "@Timestamp(key: FieldKeys.\(property.name), on \(property.fluentTimeTrigger?.rawValue ?? ".none")) var \(property.name): \(property.propertyType)\(property.optionalSuffix)"
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

    func generateMigration() -> String {
//        .id()
//        .field(___VARIABLE_ModelNameUpper___.FieldKeys.createdAt, .datetime, .required)
//        .field(___VARIABLE_ModelNameUpper___.FieldKeys.updatedAt, .datetime, .required)
        codeMigrationProperties = ""
        codeMigrationProperties = properties.map { property -> String in
            switch property.fluentPW {
            case .id:
                return ".id()"
            case .field, .timestamp:
                return ".field(\(vaporModel.name).FieldKeys.\(property.name), \(property.fluentDataType.rawValue)\(property.required))"
            default:
                return ""
            }
        }
        .joined(separator: "\n")

        if let template = readTemplateFile(name: "TemplateMigration") {
            return template
                .replacingOccurrences(of: "___VARIABLE_Properties___", with: codeMigrationProperties)
                .swiftFormat()
        }

        return codeMigrationProperties
    }
    
    func generateController() -> String {
        if let template = readTemplateFile(name: "TemplateController") {
            return template
//                .replacingOccurrences(of: "___VARIABLE_Properties___", with: codeMigrationProperties)
                .swiftFormat()
        }
        return ""
    }
}
