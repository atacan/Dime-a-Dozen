//
//  VaporProperty.swift
//  DimeADozen (iOS)
//
//  Created by atacan on 11.06.22.
//

import Foundation

struct VaporProperty: Identifiable {
    var id = UUID()
    var fluentPW: FluentPropertyWrapper {
        didSet {
            if fluentPW != .timestamp {
                fluentTimeTrigger = nil
            }
            if fluentPW != .children {
                childrenKeyPath = nil
            }
        }
    }

    var fluentTimeTrigger: FluentTimestampTrigger?
    var childrenKeyPath: String?
    var name: String
    var fluentDataType: FluentDataType
    var isOptional: Bool
    var optionalSuffix: String {
        isOptional ? "?" : ""
    }
    var required: String {
        isOptional ? "" : ", .required"
    }
//    var isRequired: Bool = true

    var fieldKey: String = ""
    var propertyType: String

    enum FluentPropertyWrapper: String, CaseIterable, Identifiable {
        var id: Self { self }
        case id = "@ID"
        case field = "@Field"
        case timestamp = "@Timestamp"
        case `enum` = "@Enum"
        case optionalField = "@OptionalField"
        case group = "@Group"
        case children = "@Children"
        case optionalChild = "@OptionalChild"
        case optionalParent = "@OptionalParent"
        case parent = "@Parent"
        case siblings = "@Siblings"
    }

    enum FluentTimestampTrigger: String, CaseIterable, Identifiable {
        var id: Self { self }
        case create = ".create"
        case update = ".update"
        case delete = ".delete"
        case none = ".none"
    }

    enum FluentDataType: String, CaseIterable, Identifiable {
        var id: Self { self }
        case string = ".string"
        case int = ".int"
        case uint = ".uint"
        case bool = ".bool"
        case datetime = ".datetime"
        case time = ".time"
        case date = ".date"
        case float = ".float"
        case double = ".double"
        case data = ".data"
        case uuid = ".uuid"
        case dictionary = ".dictionary"
        case array = ".array"
        case `enum` = ".enum"
    }

    enum SwiftType: String, CaseIterable, Identifiable {
        var id: Self { self }
        case string = "String"
        case int = "Int"
        case uint = "Uint"
        case bool = "Bool"
        case date = "Date"
        case float = "Float"
        case double = "Double"
        case data = "Data"
        case uuid = "UUID"
    }

    enum Mock {
        static let single = VaporProperty(fluentPW: .field, name: "niceField", fluentDataType: .string, isOptional: false, propertyType: "String")
    }
}

extension VaporProperty: Equatable {
    static func == (lhs: VaporProperty, rhs: VaporProperty) -> Bool {
        // << return yes on view properties which identifies that the
        // view is equal and should not be refreshed (ie. `body` is not rebuilt)
        lhs.id == rhs.id
            && lhs.fluentPW == rhs.fluentPW
            && lhs.fluentTimeTrigger == rhs.fluentTimeTrigger
            && lhs.fluentDataType == rhs.fluentDataType
            && lhs.propertyType == rhs.propertyType
            && lhs.isOptional == rhs.isOptional
    }
}
