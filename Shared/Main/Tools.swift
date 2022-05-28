// https://github.com/atacan/
// 28.05.22
//

import Foundation
import SwiftUI

struct Tool: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let destination: Destination

    init(name: String) {
        self.name = name
        self.destination = .comingSoon
    }

    init(name: String, destination: Destination) {
        self.name = name
        self.destination = destination
    }
}

class ToolsModel: ObservableObject {
    @Published var tools: [Tool] = [Tool(name: "Html to Swift", destination: .htmlToSwiftBirds("Html to Swift Converter")),
                                    Tool(name: "Vapor Model"),
                                    Tool(name: "Vapor Migration"),
                                    Tool(name: "Vapor Controller")]
}
