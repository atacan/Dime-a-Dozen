// https://github.com/atacan/
// 29.05.22
//

import SwiftUI

struct FoundFilesView: View {
    @ObservedObject var fileSearchModel: FileSearch
    @State private var selectedPeople = Set<FileModel.ID>()
    @State private var sortOrder = [KeyPathComparator(\FileModel.name)]

    var myTable: some View {
        Table(fileSearchModel.foundFiles, selection: $selectedPeople, sortOrder: $sortOrder) {
            TableColumn("File Path", value: \.name)
        }
        .onChange(of: sortOrder) {
            fileSearchModel.foundFiles.sort(using: $0)
        }
        .onChange(of: selectedPeople) { newValue in
            guard newValue.count == 1 else { return }
            fileSearchModel.selectedFile(newValue.randomElement())
        }
    }

    var myList: some View {
        List {
            ForEach(fileSearchModel.foundFiles) { file in
                Text(file.name)
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
