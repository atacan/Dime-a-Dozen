// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftSoup
import SwiftUI
import Dependencies
//import Prelude

let toolHtmlToSwift = Tool(sidebarName: "Html to Swift", navigationTitle: "Html to Swift DSL Converter")

class HtmlToSwift {
    static let shared = HtmlToSwift()
    @Dependency(\.swiftHighlightClient) var swiftHighlightClient

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
    
    func convert(html input: NSMutableAttributedString, library: SwiftDSL, htmlComponent: HtmlOutputComponent = .fullHtml) -> NSMutableAttributedString {
        return convert(html: input.string, library: library) |> standardNSAttributed
        // highlight takes too much time
//        do {
//            let swiftCode = convert(html: input.string, library: library)
//            print("swiftCode done \(Date())")
//            return try NSMutableAttributedString.init(attributedString: swiftCode |> swiftHighlightClient.convert)
//        } catch {
//            return error.localizedDescription |> standardNSAttributed(_:)
//        }
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
    
    func pretty(html: NSMutableAttributedString, htmlComponent: HtmlOutputComponent = .fullHtml) -> NSMutableAttributedString {
        pretty(html: html.string, htmlComponent: htmlComponent) |> standardNSAttributed
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
