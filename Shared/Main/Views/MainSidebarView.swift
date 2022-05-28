// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct MainSidebarView: View {
    @ObservedObject var tools = ToolsModel()
    @State private var selectedTool: Tool?

    var body: some View {
        List {
            Text("Server Side Swift")
                .font(.title3)
            ForEach(tools.tools) { tool in
                Navigator.navigate(tool.destination) {
                    Text("  " + tool.name)
                }
//                    NavigationLink(destination: InputToOutputView(toolName: tool.name), tag: tool, selection: $selectedTool) {
//                        Text(tool.name)
//                    } // <-NavigationLink
            } // <-ForEach
        } // <-List
        .listStyle(.sidebar)
        .frame(minWidth: 200)
    }
}

struct MainSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        MainSidebarView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
