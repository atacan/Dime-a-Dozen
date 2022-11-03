//
//  RegexViewModel.swift
//  DimeADozen
//
//  Created by atacan on 04.06.22.
//

import SwiftUI
import Prelude

extension String {
    func parts(like pattern: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsrange = NSRange(startIndex ..< endIndex, in: self)
            let nsSelf = self as NSString
            let matches = regex.matches(in: self, options: [], range: nsrange)
            return matches.map { nsSelf.substring(with: $0.range) }
        } catch {
            print("NSRegularExpression initilization", error.localizedDescription)
            return nil
        }
    }
}

class RegexViewModel: ObservableObject {
    @Published var input = NSMutableAttributedString()
    var inputText: String {
        input.string
    }
    @Published var output = NSMutableAttributedString()
    var outputText: String{
        output.string
    }

    func regexMatches(of pattern: String) {
        if let matches = inputText.parts(like: pattern) {
            output = matches.joined(separator: "\n") |> standardNSAttributed
        }
    }
}
