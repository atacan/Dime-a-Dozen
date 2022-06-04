// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            MainSidebarView()
            Text("⬅️ Choose a tool from the Sidebar")
                .font(.largeTitle)
        } // <-NavigationView
        .navigationTitle("Tools")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                ToggleSidebarButton()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
