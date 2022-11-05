// https://github.com/atacan/
// 29.05.22
//

import SwiftUI

let toolSearchTextFiles = Tool(sidebarName: "Search File Content", navigationTitle: "Find Files that Contain a Text")

struct SearchTextFilesView: View {
    @Binding var selectedTool: Tool?
    @StateObject var fileSearchModel = FileSearch()
    @State var pickedPath: String = ""
    @State var files: [String] = []

    var myView: some View {
        VStack(alignment: .center) {
            ButtonFilePickerPanelView(fileSearchModel: fileSearchModel)
            VSplitView {
                FoundFilesView(fileSearchModel: fileSearchModel)
                FileContentView(fileSearchModel: fileSearchModel)
            } // <-VSplitView
        } // <-VStack
        .navigationTitle(toolSearchTextFiles.navigationTitle)
    }

    var body: some View {
        NavigationLink(destination: myView, tag: toolSearchTextFiles, selection: $selectedTool) {
            Text(toolSearchTextFiles.sidebarName)
        } // <-NavigationLink
    }
}

// struct SearchTextFilesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchTextFilesView(files: PreviewData.Files.files)
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
