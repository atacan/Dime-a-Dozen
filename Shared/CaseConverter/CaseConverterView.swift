//
//  CaseConverterView.swift
//  DimeADozen (iOS)
//
//  Created by atacan.durmusoglu on 04.06.22.
//

import SwiftUI

let toolCaseConverter = Tool(sidebarName: "Case Converter", navigationTitle: "Convert Word Case")

struct CaseConverterView: View {
    @StateObject var caseConversionVM = CaseConversionViewModel()
    @Binding var selectedTool: Tool?
    @State private var inputCase: WordGroupCase = .kebab
    @State private var outputCase: WordGroupCase = .camel
    
    var myInputEditor: some View {
        VStack(alignment: .center) {
            Text("List of Words")
                .font(.title2)
            TextEditor(text: $caseConversionVM.inputText)
                .font(.monospaced(.body)())
                .padding(.horizontal)
                .padding(.bottom)
        } // <-VStack
    }
    
    var myOutputEditor: some View {
        VStack(alignment: .center) {
            Text("Converted")
                .font(.title2)
            TextEditor(text: $caseConversionVM.outputText)
                .font(.monospaced(.body)())
                .padding(.horizontal)
                .padding(.bottom)
        } // <-VStack
    }
    
    var myView: some View {
        VStack {
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
            .padding(.top)
            Button {
                caseConversionVM.convert(from: inputCase, to: outputCase)
            } label: {
                Text("Convert")
            } // <-Button
            .padding(.top)
            .keyboardShortcut(.return, modifiers: .command)
            HSplitView {
                myInputEditor
                myOutputEditor
            } // <-HSplitView
        } // <-VStack
        .frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        .navigationTitle(toolCaseConverter.navigationTitle)
    }
    
    var body: some View {
        NavigationLink(destination: myView, tag: toolCaseConverter, selection: $selectedTool) {
            Text(toolCaseConverter.sidebarName)
        } // <-NavigationLink
    }
}
