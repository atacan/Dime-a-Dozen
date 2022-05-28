// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift

class HtmlToSwiftBirds {
    static let shared = HtmlToSwiftBirds()
    
//    var input: String
//    var output: String
//
//    init(input: String, output: String) {
//        self.input = input
//        self.output = output
//    }

    func convert(html input: String) -> String {
        do {
            let swift = try Converter.default.convert(html: input)
            return swift
        } catch {
            return error.localizedDescription
        }
    }
}
