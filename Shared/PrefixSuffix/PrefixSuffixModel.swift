//
// https://github.com/atacan
// 25.06.22

import Cocoa
import Combine
import Prelude

private extension String {
    mutating func append(prefix: String) {
        self = prefix + self
    }

    func leadingWhiteSpace() -> Substring {
        let regexLeadingWhiteSpace = #"^\s*"#
        if let leadingWhiteRange = range(of: regexLeadingWhiteSpace, options: .regularExpression) {
            return self[leadingWhiteRange]
        }
        return ""
    }

    func trailingWhiteSpace() -> Substring {
        let regexTrailingWhiteSpace = #"\s*$"#
        if let trailingWhiteRange = range(of: regexTrailingWhiteSpace, options: .regularExpression) {
            return self[trailingWhiteRange]
        }
        return ""
    }
}

class PrefixSuffixModel: ObservableObject {
    @Published var input = NSMutableAttributedString()
    var inputText: String {
        input.string
    }

    @Published var output = NSMutableAttributedString()
    var outputText: String {
        output.string
    }

    @Published var prefixReplace = ""
    @Published var prefixReplaceWith = ""
    @Published var prefixAdd = ""
    @Published var suffixReplace = ""
    @Published var suffixReplaceWith = ""
    @Published var suffixAdd = ""
    @Published var separator: WordGroupSeperator = .newLine
    @Published var trimWhiteSpace = false

    func split() -> [String] {
        return inputText.components(separatedBy: .newlines)
    }

    func convertEach(input: String) -> String {
        let leadingWhite = input.leadingWhiteSpace()
        let trailingWhite = input.trailingWhiteSpace()

        var output = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if output.hasPrefix(prefixReplace) {
            output = String(output.dropFirst(prefixReplace.count))
            output.append(prefix: prefixReplaceWith)
        }
        if !prefixAdd.isEmpty {
            output.append(prefix: prefixAdd)
        }
        if output.hasSuffix(suffixReplace) {
            output = String(output.dropLast(suffixReplace.count))
            output.append(suffixReplaceWith)
        }
        if !suffixAdd.isEmpty {
            output.append(suffixAdd)
        }

        if !trimWhiteSpace {
            return leadingWhite + output + trailingWhite
        } else {
            return output
        }
    }

    func convert() {
        let inputs = split()
        output = inputs.map(convertEach)
            .joined(separator: "\n")
            |> standardNSAttributed
    }
}
