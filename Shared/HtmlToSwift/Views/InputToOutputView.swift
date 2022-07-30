// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct InputToOutputView: View {
    var toolTitle: String
    @State var libraryChoice: SwiftDSL = .pointFree
    
    @State var inputText: String = ""
//    @SceneStorage("inputText") var inputText: String = ""
    @State var inputTitle: String = "HTML Input"
    @State var inputFootNote: String = ""
    @State var inputLanguage: String = ""

    @State var outputText: String = ""
    @State var outputTitle: String = "Swift Output"
    @State var outputFootNote: String = " "
    @State var outputLanguage: String = ""

    var body: some View {
        VStack(alignment: .center) {
            Picker("DSL Package:", selection: $libraryChoice) {
                ForEach(SwiftDSL.allCases) { lib in
                    Text(lib.rawValue)
//                        .font(.monospaced(.body)())
                }
            }
            .pickerStyle(.radioGroup)
            .horizontalRadioGroupLayout()
            .help("Fluent Property Wrapper")
            .padding(.top)
            
            Button {
                outputText = HtmlToSwift.shared.convert(html: inputText, library: libraryChoice)
            } label: {
                Text("Convert")
            } // <-Button
            .keyboardShortcut(.return, modifiers: .command)
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

//struct InputToOutputView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputToOutputView(toolTitle: "Converter", inputToOutputConverter: HtmlToSwiftBirds.shared.convert)
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
