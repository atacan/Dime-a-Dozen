//
//  TextStyle.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 05.06.22.
//

enum WordCase {
    case title
    case allDown
    case allCaps
}

enum WordGroupCase: String, CaseIterable, Identifiable  {
    case snake
    case kebab
    case camel
    case pascal
    var id: Self { self }
    
    func textStyle() -> TextStyle.Type {
        switch self {
        case .snake:
            return Snake.self
        case .kebab:
            return Kebab.self
        case .camel:
            return Camel.self
        case .pascal:
            return Pascal.self
        }
    }
}

protocol TextStyle {
    var style: WordGroupCase { get }
    var separator: String { get }
    var firstWordCase: WordCase { get }
    var restWordCase: WordCase { get }
    var content: String { get set }
    init(_ content: String)
    init(from words: [Substring])
    func split() -> [Substring]
}
