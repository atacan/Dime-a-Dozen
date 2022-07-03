//
//  VaporCodeViewModel.swift
//  DimeADozen
//
//  Created by atacan on 11.06.22.
//

import Combine
import Foundation
import SwiftFormat
import SwiftUI

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
    @Published var modelName: String = "ModelName"
    var vaporModel: VaporModel = .init(name: "")
    var codeModelFieldKeys: String = ""
    var codeModelProperties: String = ""
    var codeMigrationProperties: String = ""
    
    @Published var codeModel: String = ""
    @Published var codeMigration: String = ""
    @Published var codeContoller: String = ""

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
    
    func generate() {
        createModel()
        generateModelCode()
        generateMigration()
        generateController()
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
    
    @discardableResult
    func generateModelCode() -> String {
        // read Model template file
        let fieldKeys =  generateModelFieldKeys()
        let modelProperties = generateModelProperties()
        let initialiser = generateModelInitialiser()
        if let template = readTemplateFile(name: "TemplateModel") {
            codeModel = template
                .replacingOccurrences(of: "___VARIABLE_PropertiesFieldKeys___", with: fieldKeys)
                .replacingOccurrences(of: "___VARIABLE_Properties___", with: modelProperties)
                .replacingOccurrences(of: "___VARIABLE_Init___", with: initialiser)
                .swiftFormat()
            return codeModel
        } else {
            codeModel = fieldKeys + "\n\n" + modelProperties
            return codeModel
        }
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
                return "@Timestamp(key: FieldKeys.\(property.name), on: \(property.fluentTimeTrigger?.rawValue ?? ".none")) var \(property.name): \(property.propertyType)\(property.optionalSuffix)"
            default:
                return ""
            }
        }
        .joined(separator: "\n")

        return codeModelProperties
    }
    
    func generateModelInitialiser() -> String {
        var arguments = Array<String>()
        var initBody = ""
        properties.forEach { property in
            let argument = "\(property.name): \(property.propertyType)\(property.optionalSuffix)"
            arguments.append(argument)
            
            let line = "self.\(property.name) = \(property.name)\n"
            initBody.append(line)
        }
        let args = arguments.joined(separator: ", ")
        return """
                  init(\(args)) {
                    \(initBody)
                  }
                """
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
    
    @discardableResult
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
            codeMigration = template
                .replacingOccurrences(of: "___VARIABLE_Properties___", with: codeMigrationProperties)
                .swiftFormat()
            return codeMigration
        } else {
            return codeMigrationProperties
        }
    }
    
    @discardableResult
    func generateController() -> String {
        if let template = readTemplateFile(name: "TemplateController") {
            codeContoller = template
//                .replacingOccurrences(of: "___VARIABLE_Properties___", with: codeMigrationProperties)
                .swiftFormat()
            return codeContoller
        }
        return ""
    }
    
    func saveFiles() {
        func saveFile(_ code: String, directory: URL, fileName: String) {
            let fileUrl = directory.appendingPathComponent(fileName)
            do {
                try code.write(to: fileUrl, atomically: true, encoding: .utf8)
            } catch {
                print(error)
            }
        }

        let fileManager = FileManager.default
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select"
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { [weak self] result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let selectedUrl = openPanel.url, let vaporModel = self?.vaporModel, let codeModel = self?.codeModel, let codeMigration = self?.codeMigration, let codeContoller = self?.codeContoller {
                    let directoryToSave = selectedUrl.appendingPathComponent(vaporModel.name)
                    try? fileManager.createDirectory(at: directoryToSave, withIntermediateDirectories: false)
                    saveFile(codeModel, directory: directoryToSave, fileName: vaporModel.name + ".swift")
                    saveFile(codeMigration, directory: directoryToSave, fileName: vaporModel.name + "Migration" + ".swift")
                    saveFile(codeContoller, directory: directoryToSave, fileName: vaporModel.name + "Controller" + ".swift")
                }
            }
        }
    }

}
