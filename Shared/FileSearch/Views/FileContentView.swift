// https://github.com/atacan/
// 29.05.22
//

import SwiftUI

struct FileContentView: View {
    @ObservedObject var fileSearchModel: FileSearch

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(NSColor.textBackgroundColor))
                Text(fileSearchModel.selectedFileContent)
                    .font(.monospaced(.body)())
                    .textSelection(.enabled)
                    .padding(.leading)
            } // <-ZStack
            .overlay(alignment: .topTrailing) {
                if let selectedFile = fileSearchModel.selectedFile {
                    Button {
                        NSWorkspace.shared.open(selectedFile.url)
                    } label: {
                        Text("Open")
                    } // <-Button
                    .padding()
                }
            }
        } // <-ScrollView
    }
}

// struct FileContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileContentView()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
