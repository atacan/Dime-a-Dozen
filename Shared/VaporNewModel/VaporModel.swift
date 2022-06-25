//
//  VaporModel.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 11.06.22.
//

struct VaporModel {
    let name: String
    let schema: String
    let route: String
    
    init(name: String) {
        self.name = name
        self.schema = name.lowercased()
        self.route = name.lowercased()
    }
}
