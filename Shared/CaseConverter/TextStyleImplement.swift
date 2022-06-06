//
//  TextStyleImplement.swift
//  DimeADozen
//
//  Created by atacan on 05.06.22.
//

import Foundation

struct Camel: TextStyle {
    var style = WordGroupCase.camel
    var separator = ""
    var firstWordCase = WordCase.allDown
    var restWordCase = WordCase.title
    var regexPatterns = ["([A-Z]+)([A-Z][a-z]|[0-9])", "([a-z])([A-Z]|[0-9])", "([0-9])([A-Z])"]
    
    func formatFirstWord(_ word: String) -> String { word.lowercased() }
    func formatRestWord(_ word: String) -> String { word.capitalized }
    
    var content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    init(from words: [Substring]) {
        content = ""
        let text = words
            .enumerated()
            .map { $0.offset == 0 ? formatFirstWord(String($0.element)) : formatRestWord(String($0.element)) }
            .joined(separator: separator)
        content = text
    }
    
    func split() -> [Substring] {
        var output = content
        let sep = Character("*")
        for pattern in regexPatterns {
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: output.count)
            if let outputInter = regex?.stringByReplacingMatches(in: output, options: [], range: range, withTemplate: "$1\(sep)$2") {
                output = outputInter
            }
        }
        return output.split(separator: sep)
    }
}

struct Pascal: TextStyle {
    var style = WordGroupCase.camel
    var separator = ""
    var firstWordCase = WordCase.title
    var restWordCase = WordCase.title
    var regexPatterns = ["([A-Z]+)([A-Z][a-z]|[0-9])", "([a-z])([A-Z]|[0-9])", "([0-9])([A-Z])"]
    
    var content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    init(from words: [Substring]) {
        content = ""
        let text = words
            .map { $0.capitalized }
            .joined(separator: separator)
        content = text
    }
    
    func split() -> [Substring] {
        var output = content
        let sep = Character("*")
        for pattern in regexPatterns {
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: output.count)
            if let outputInter = regex?.stringByReplacingMatches(in: output, options: [], range: range, withTemplate: "$1\(sep)$2") {
                output = outputInter
            }
        }
        return output.split(separator: sep)
    }
}

struct Kebab: TextStyle {
    var style = WordGroupCase.camel
    var separator = "-"
    var firstWordCase = WordCase.allDown
    var restWordCase = WordCase.allDown
    var content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    init(from words: [Substring]) {
        content = ""
        let text = words
            .map { $0.lowercased() }
            .joined(separator: separator)
        content = text
    }
    
    func split() -> [Substring] {
        return content.split(separator: Character(separator))
    }
}

struct Snake: TextStyle {
    var style = WordGroupCase.camel
    var separator = "_"
    var firstWordCase = WordCase.allDown
    var restWordCase = WordCase.allDown
    var content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    init(from words: [Substring]) {
        content = ""
        let text = words
            .map { $0.lowercased() }
            .joined(separator: separator)
        content = text
    }
    
    func split() -> [Substring] {
        return content.split(separator: Character(separator))
    }
}
