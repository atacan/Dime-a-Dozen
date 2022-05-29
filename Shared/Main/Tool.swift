// https://github.com/atacan/
// 28.05.22
//

import Foundation
import SwiftUI

struct Tool: Identifiable, Hashable {
    let id = UUID()
    let sidebarName: String
    let navigationTitle: String

    init(sidebarName: String, navigationTitle: String) {
        self.sidebarName = sidebarName
        self.navigationTitle = navigationTitle
    }
}
