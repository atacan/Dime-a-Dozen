// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct InputToOutputView: View {
    var toolTitle: String
    let inputToOutputConverter: (String) -> String
    @State var inputText: String = ""
    @State var inputTitle: String = "HTML Input"
    @State var inputFootNote: String = "Enclose the whole code inside one tag"
    @State var inputLanguage: String = ""

    @State var outputText: String = ""
    @State var outputTitle: String = "SwiftHtml Output"
    @State var outputFootNote: String = " "
    @State var outputLanguage: String = ""

    var body: some View {
        VStack(alignment: .center) {
            Button {
                outputText = inputToOutputConverter(inputText)
            } label: {
                Text("Convert")
            } // <-Button
            .padding(.top)
            HSplitView {
                UserEditorView(text: $inputText, title: $inputTitle, footNote: $inputFootNote, language: $inputLanguage)
                UserEditorView(text: $outputText, title: $outputTitle, footNote: $outputFootNote, language: $outputLanguage)
            } // <-HSplitView
        } // <-VStack
        .frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        .navigationTitle(toolTitle)
    }
}

struct InputToOutputView_Previews: PreviewProvider {
    static var previews: some View {
        InputToOutputView(toolTitle: "Converter", inputToOutputConverter: HtmlToSwiftBirds.shared.convert)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
