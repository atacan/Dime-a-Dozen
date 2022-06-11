// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            MainSidebarView()
                .toolbar {
                    ToolbarItem(placement: .status) {
                        ToggleSidebarButton()
                    }
                }
            Text("\(Image(systemName: "sidebar.squares.left"))  Choose a tool from the Sidebar")
                .font(.largeTitle)
        } // <-NavigationView
        .navigationTitle("Tools")
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
