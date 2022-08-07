// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftUI

struct InputToOutputView: View {
    var toolTitle: String
    @State var libraryChoice: SwiftDSL = .pointFree
    @State var htmlComponentChoice: HtmlOutputComponent = .fullHtml
    @State var formatHtml: Bool = false

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
            .help("DSL library that the output is for")
            .padding(.top)

            Picker("HTML Component:", selection: $htmlComponentChoice) {
                ForEach(HtmlOutputComponent.allCases) { comp in
                    Text(comp.rawValue)
//                        .font(.monospaced(.body)())
                }
            }
            .pickerStyle(.inline)
            .horizontalRadioGroupLayout()
            .help("DSL library that the output is for")
            .padding(.top)

            Toggle("Reformat Html", isOn: $formatHtml)
                .help("DSL library that the output is for")
                .padding(.top)

            Button {
                outputText = HtmlToSwift.shared.convert(html: inputText, library: libraryChoice, htmlComponent: htmlComponentChoice)

                if formatHtml { inputText = HtmlToSwift.shared.pretty(html: inputText, htmlComponent: htmlComponentChoice) }
            } label: {
                Text("Convert")
            } // <-Button
            .keyboardShortcut(.return, modifiers: .command)
            .help("Convert to Swift ⌘↵")
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

// struct InputToOutputView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputToOutputView(toolTitle: "Converter", inputToOutputConverter: HtmlToSwiftBirds.shared.convert)
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
