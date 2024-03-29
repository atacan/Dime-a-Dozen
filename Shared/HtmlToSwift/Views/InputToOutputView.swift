// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftUI

struct InputToOutputView: View {
    var toolTitle: String
//    @State var libraryChoice: SwiftDSL = .pointFree
    @AppStorage("libraryChoice") var libraryChoice: SwiftDSL = .pointFree
    @AppStorage("htmlComponentChoice") var htmlComponentChoice: HtmlOutputComponent = .fullHtml
    @AppStorage("formatHtml") var formatHtml: Bool = false

    @State var inputText = NSMutableAttributedString(attributedString: standardNSAttributed(""))
//    @SceneStorage("inputText") var inputText: String = ""
    @State var inputTitle: String = "HTML Input"
    @State var inputFootNote: String = ""
    @State var inputLanguage: String = ""

    @State var outputText = NSMutableAttributedString(attributedString: standardNSAttributed(""))
    @State var outputTitle: String = "Swift Output"
    @State var outputFootNote: String = " "
    @State var outputLanguage: String = ""

    @State var copyButtonAnimating = false

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
            .help("what the result should contain from the inputted Html code")
            .padding(.top)

            Toggle("Reformat Html", isOn: $formatHtml)
                .help("pretty format the Html input")
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
                    .overlay(alignment: .topTrailing) {
                        AnimatingCopyButton(copyButtonAnimating: $copyButtonAnimating, outputText: $outputText)
                            .padding(.trailing, 22).padding(.top, 38)
                    }
//                    .colorScheme(.dark)
//                    .preferredColorScheme(.dark)
            } // <-HSplitView
        } // <-VStack
        .frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        .navigationTitle(toolTitle)
        .onReceive(topMenu.copyOutputCommand) { _ in
            CopyClient.liveValue.copyToClipboard(outputText)
        }
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
