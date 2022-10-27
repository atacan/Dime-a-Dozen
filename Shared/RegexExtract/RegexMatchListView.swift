//
//  RegexMatchListView.swift
//  DimeADozen (iOS)
//
//  Created by atacan on 04.06.22.
//

import MacSwiftUI
import SwiftUI

let toolRegexMatchList = Tool(sidebarName: "Regex Matches", navigationTitle: "Extract Regex Matches")

struct RegexMatchListView: View {
    @StateObject var regexVM = RegexViewModel()
    @Binding var selectedTool: Tool?
//    @State var regexPattern: String = ""
    @SceneStorage("regexPattern") var regexPattern: String = ""
    @State var copyButtonAnimating = false

    var myInputEditor: some View {
        VStack(alignment: .center) {
            Text("Input Text")
                .font(.title2)
            MacEditorControllerView(text: $regexVM.inputText)
                .font(.monospaced(.body)())
                .shadow(radius: 2)
                .padding(.horizontal)
                .padding(.bottom)
        } // <-VStack
    }

    var myOutputEditor: some View {
        VStack(alignment: .center) {
            Text("Regex Matches")
                .font(.title2)
            MacEditorControllerView(text: $regexVM.outputText)
                .font(.monospaced(.body)())
                .shadow(radius: 2)
                .padding(.horizontal)
                .padding(.bottom)
        } // <-VStack
    }

    var myView: some View {
        VStack {
            PatternInputView(regexVM: regexVM, pattern: $regexPattern)
                .padding()
            HSplitView {
                myInputEditor
                myOutputEditor
                    .overlay(alignment: .topTrailing) {
                        AnimatingCopyButton(copyButtonAnimating: $copyButtonAnimating, outputText: $regexVM.outputText)
                            .padding(.trailing, 22).padding(.top, 38)
                    }
            } // <-HSplitView
        } // <-VStack
        .frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity, minHeight: 300, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        .navigationTitle(toolRegexMatchList.navigationTitle)
    }

    var body: some View {
        NavigationLink(destination: myView, tag: toolRegexMatchList, selection: $selectedTool) {
            Text(toolRegexMatchList.sidebarName)
        } // <-NavigationLink
    }
}

// struct RegexMatchListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegexMatchListView()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
