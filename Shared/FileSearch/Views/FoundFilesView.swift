// https://github.com/atacan/
// 29.05.22
//

import SwiftUI

struct FoundFilesView: View {
    @ObservedObject var fileSearchModel: FileSearch
    @State private var selectedFile: FileModel.ID? = nil
    @State private var sortOrder = [KeyPathComparator(\FileModel.path)]

    var myTable: some View {
        Table(fileSearchModel.foundFiles, selection: $selectedFile, sortOrder: $sortOrder) {
            TableColumn("File Path", value: \.path)
        }
        .onChange(of: sortOrder) {
            fileSearchModel.foundFiles.sort(using: $0)
        }
        .onChange(of: selectedFile) { _ in
            fileSearchModel.selectedFile(selectedFile)
        }
    }

    var myList: some View {
        List {
            ForEach(fileSearchModel.foundFiles) { file in
                Text(file.path)
                    .onTapGesture {
                        fileSearchModel.selectedFile = file
                    }
            } // <-ForEach
        } // <-List
    }

    var body: some View {
        myTable
    }
}

// struct FoundFilesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FoundFilesView(files: PreviewData.Files.files)
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
