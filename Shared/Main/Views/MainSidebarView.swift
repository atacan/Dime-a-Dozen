// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct MainSidebarView: View {
    #if DEBUG
        @State private var selectedTool: Tool? = toolPrefixSuffix
    #else
        @State private var selectedTool: Tool?
    #endif

    var body: some View {
        List {
            Section(header: Text("Server Side Swift")) {
//                HtmlToPointFreeView(selectedTool: $selectedTool)
                HtmlToSwiftBirdsView(selectedTool: $selectedTool)
                VaporCodeFinalView(selectedTool: $selectedTool)
            }
            Section(header: Text("Text")) {
                RegexMatchListView(selectedTool: $selectedTool)
                CaseConverterView(selectedTool: $selectedTool)
                PrefixSuffixFinalView(selectedTool: $selectedTool)
                JsonPrettyView(selectedTool: $selectedTool, store: jsonStore)
            }
            Section(header: Text("Files")) {
                SearchTextFilesView(selectedTool: $selectedTool)
            }
        }
        // <-List
            .listStyle(.sidebar)
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
