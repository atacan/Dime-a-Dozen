// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftUI

let toolHtmlToSwiftBirds = Tool(sidebarName: "Html to swift-html", navigationTitle: "Html to Swift-Html Converter")

class HtmlToSwiftBirds {
    static let shared = HtmlToSwiftBirds()

    func convert(html input: String) -> String {
        do {
            let swift = try Converter.default.convert(html: input)
            return swift
        } catch {
            return error.localizedDescription
        }
    }
}

struct HtmlToSwiftBirdsView: View {
    @Binding var selectedTool: Tool?

    var body: some View {
        NavigationLink(destination: InputToOutputView(toolTitle: toolHtmlToSwiftBirds.navigationTitle,
                                                      inputToOutputConverter: HtmlToSwiftBirds.shared.convert),
                       tag: toolHtmlToSwiftBirds, selection: $selectedTool) {
            Text(toolHtmlToSwiftBirds.sidebarName)
        } // <-NavigationLink
    }
}
