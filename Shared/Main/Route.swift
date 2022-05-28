// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

enum Destination: Hashable {
    case htmlToSwiftBirds(String)
    case comingSoon
}

enum Navigator {
    static func navigate<T: View>(_ destination: Destination, content: () -> T) -> AnyView {
        switch destination {
        case .htmlToSwiftBirds(let title):
            return AnyView(
                NavigationLink(destination: InputToOutputView(toolName: title)) {
                    content()
                } // <-NavigationLink
            )
        default:
            return AnyView(
                NavigationLink(destination: ComingSoonView()) {
                    content()
                } // <-NavigationLink
            )
        }
    }
}
