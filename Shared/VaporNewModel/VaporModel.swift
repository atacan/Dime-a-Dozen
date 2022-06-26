//
//  VaporModel.swift
//  DimeADozen
//
//  Created by atacan on 11.06.22.
//

struct VaporModel {
    let name: String
    let schema: String
    let route: String
    let queryParameter: String
    
    let nameLower: String
    let nameLowerPlural: String
    
    init(name: String) {
        self.name = name
        self.schema = name.lowercased()
        self.route = name.lowercased()
        self.queryParameter = name.lowercased() + "ID"
        
        self.nameLower = name.lowercased()
        self.nameLowerPlural = name.lowercased() + "s"
    }
}
