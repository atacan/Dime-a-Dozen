// https://github.com/atacan/
// 29.05.22
//

import SwiftUI

struct ButtonFilePickerPanelView: View {
    @ObservedObject var fileSearchModel: FileSearch

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            TextField("Text to search", text: $fileSearchModel.searchText)
                .onSubmit {
                    fileSearchModel.filePicker()
                }
                .frame(width: 200, alignment: .top)
            Button {
                fileSearchModel.filePicker()
            } label: {
                Text("Search in \(Image(systemName: "folder")) Directory...")
            } // <-Button
            Spacer()
        } // <-HStack
        .padding(.top)
    }
}

// struct ButtonFilePickerPanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonFilePickerPanelView(foundFiles: .constant(PreviewData.Files.files))
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
