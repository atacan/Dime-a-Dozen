//
//  String+Regex.swift
//  DimeADozen (iOS)
//
//  Created by atacan.durmusoglu on 04.06.22.
//

import Foundation

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
