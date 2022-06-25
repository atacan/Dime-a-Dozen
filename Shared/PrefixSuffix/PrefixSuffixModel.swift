//
// https://github.com/atacan
// 25.06.22

import Combine

private extension String {
    mutating func append(prefix: String) {
        self = prefix + self
    }
}

class PrefixSuffixModel: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var prefixReplace = ""
    @Published var prefixReplaceWith = ""
    @Published var prefixAdd = ""
    @Published var suffixReplace = ""
    @Published var suffixReplaceWith = ""
    @Published var suffixAdd = ""
    @Published var separator: WordGroupSeperator = .newLine

    func split() -> [String] {
        return inputText.components(separatedBy: .newlines)
    }

    func convertEach(input: String) -> String {
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
        return output
    }

    func convert() {
        let inputs = split()
        outputText = ""
        inputs.forEach { input in
            outputText.append(convertEach(input: input) + "\n")
        }
    }
}
