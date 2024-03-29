//
//  CaseConverterView.swift
//  DimeADozen (iOS)
//
//  Created by atacan on 04.06.22.
//

import MacSwiftUI
import Prelude
import SwiftUI

let toolCaseConverter = Tool(sidebarName: "Case Converter", navigationTitle: "Convert Word Case")

struct CaseConverterView: View {
    var caseConversionVM = CaseConversionViewModel()
    @Binding var selectedTool: Tool?
    @State var inputText = NSMutableAttributedString()
    @State var outputText = NSMutableAttributedString()
    @State private var inputCase: WordGroupCase = .kebab
    @State private var outputCase: WordGroupCase = .camel
    @State private var seperator: WordGroupSeperator = .newLine
    @State var copyButtonAnimating = false

    var myInputEditor: some View {
        VStack(alignment: .center) {
            Text("List of Words")
                .font(.title2)
            MacEditorView(text: $inputText)
                .disableAutocorrection(true)
                .font(.monospaced(.body)())
                .shadow(radius: 2)
                .padding(.horizontal)
                .padding(.bottom)
        } // <-VStack
    }

    var myOutputEditor: some View {
        VStack(alignment: .center) {
            Text("Converted")
                .font(.title2)
            MacEditorView(text: $outputText, isRichText: false)
                .font(.monospaced(.body)())
                .shadow(radius: 2)
                .padding(.horizontal)
                .padding(.bottom)
                .overlay(alignment: .topTrailing) {
                    AnimatingCopyButton(copyButtonAnimating: $copyButtonAnimating, outputText: $outputText)
                        .padding(.trailing, 22).padding(.top, 12)
                }
        } // <-VStack
    }

    var myView: some View {
        VStack {
            Button {
                (inputCase, outputCase) = (outputCase, inputCase)
            } label: {
                Image(systemName: "arrow.left.arrow.right")
            } // <-Button
            .padding(.top)
            HStack {
                Spacer()
                Picker("Input Case", selection: $inputCase) {
                    ForEach(WordGroupCase.allCases) { wordGroup in
                        Text(wordGroup.rawValue.capitalized)
                    }
                }
                .frame(maxWidth: 250)
                Picker("Output Case", selection: $outputCase) {
                    ForEach(WordGroupCase.allCases) { wordGroup in
                        Text(wordGroup.rawValue.capitalized)
                    }
                }
                .frame(maxWidth: 250)
                Spacer()
            }
            Picker("Word Group Seperator", selection: $seperator) {
                ForEach(WordGroupSeperator.allCases) { seperator in
                    Text(caseConversionVM.seperatorDescription(seperator))
                }
            }
            .pickerStyle(.inline)
            .frame(maxWidth: 250)

            Button {
                outputText = caseConversionVM.convert(inputText: inputText.string, from: inputCase, to: outputCase) |> standardNSAttributed
            } label: {
                Text("Convert")
            } // <-Button
            .help("Convert the cases ⌘↵")
            .padding(.top)
            .keyboardShortcut(.return, modifiers: .command)
            HSplitView {
                myInputEditor
                myOutputEditor
            } // <-HSplitView
        } // <-VStack
        .frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        .navigationTitle(toolCaseConverter.navigationTitle)
        .onReceive(topMenu.copyOutputCommand) { _ in
            CopyClient.liveValue.copyToClipboard(outputText)
        }
    }

    var body: some View {
        NavigationLink(destination: myView, tag: toolCaseConverter, selection: $selectedTool) {
            Text(toolCaseConverter.sidebarName)
        } // <-NavigationLink
    }
}
