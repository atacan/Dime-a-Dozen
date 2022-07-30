// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftUI

let toolHtmlToSwift = Tool(sidebarName: "Html to Swift", navigationTitle: "Html to Swift DSL Converter")

class HtmlToSwift {
    static let shared = HtmlToSwift()

    func convert(html input: String, library: SwiftDSL) -> String {
        do {
            switch library {
            case .pointFree:
                return try convertToPointFree(html: input)
            case .binaryBirds:
                return try convertToBinaryBirds(html: input)
            }
            
        } catch {
            return error.localizedDescription
        }
    }
}

struct HtmlToSwiftBirdsView: SwiftUI.View {
    @Binding var selectedTool: Tool?

    var body: some SwiftUI.View {
        NavigationLink(destination: InputToOutputView(toolTitle: toolHtmlToSwift.navigationTitle),
                       tag: toolHtmlToSwift, selection: $selectedTool) {
            Text(toolHtmlToSwift.sidebarName)
        } // <-NavigationLink
    }
}

enum SwiftDSL: String, CaseIterable, Identifiable {
    var id: Self { self }
    case pointFree = "Point-Free Co."
    case binaryBirds = "Binary Birds (Feather)"
}
