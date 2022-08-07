// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftSoup
import SwiftUI

let toolHtmlToSwift = Tool(sidebarName: "Html to Swift", navigationTitle: "Html to Swift DSL Converter")

class HtmlToSwift {
    static let shared = HtmlToSwift()

    func convert(html input: String, library: SwiftDSL, htmlComponent: HtmlOutputComponent = .fullHtml) -> String {
        do {
            switch library {
            case .pointFree:
                return try convertToPointFree(html: input, component: htmlComponent)
            case .binaryBirds:
                return try convertToBinaryBirds(html: input, component: htmlComponent)
            }
            
        } catch {
            return error.localizedDescription
        }
    }
    
    func pretty(html: String, htmlComponent: HtmlOutputComponent = .fullHtml) -> String {
        do {
            let doc = try SwiftSoup.parse(html)
            let root: SwiftSoup.Element?
            
            switch htmlComponent {
            case .fullHtml:
                root = doc.child(0)
            case .onlyBody:
                root = doc.body()
            case .onlyHead:
                root = doc.head()
            }
            if let root = root {
                return try root.html()
            } else {
                return html
            }
        } catch {
            return html
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
