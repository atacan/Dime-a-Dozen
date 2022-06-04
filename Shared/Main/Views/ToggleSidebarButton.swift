// https://github.com/atacan/
// 29.05.22
//

import SwiftUI

struct ToggleSidebarButton: View {
    var body: some View {
        Button {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        } label: {
            Label("Toggle sidebar", systemImage: "sidebar.left")
        }
    }
}

struct ToggleSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleSidebarButton()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
