//
//  RegexViewModel.swift
//  DimeADozen
//
//  Created by atacan.durmusoglu on 04.06.22.
//

import SwiftUI

class RegexViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var outputText: String = ""

    func regexMatches(of pattern: String) {
        if let matches = inputText.parts(like: pattern) {
            outputText = matches.joined(separator: "\n")
        }
    }
}
