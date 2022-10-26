//
// https://github.com/atacan
// 25.06.22

import MacSwiftUI
import SwiftUI

let toolPrefixSuffix = Tool(sidebarName: "Prefix Suffix Replace", navigationTitle: "Replace and Add Prefix and Suffix")

struct PrefixSuffixFinalView: View {
    @Binding var selectedTool: Tool?
    @StateObject var vm = PrefixSuffixModel()
    @State var copyButtonAnimating = false

    var myView: some View {
        VStack(alignment: .center) {
            UserInputPrefixSuffix(vm: vm, prefixReplace: $vm.prefixReplace, prefixReplaceWith: $vm.prefixReplaceWith, prefixAdd: $vm.prefixAdd, suffixReplace: $vm.suffixReplace, suffixReplaceWith: $vm.suffixReplaceWith, suffixAdd: $vm.suffixAdd, trimWhiteSpace: $vm.trimWhiteSpace)
                .padding()
            HSplitView {
                MacEditorControllerView(text: $vm.inputText)
                    .padding()
                MacEditorControllerView(text: $vm.outputText)
                    .padding()
                    .overlay(alignment: .topTrailing) {
                        Button {
                            copyButtonAnimating = true
                            CopyClient.liveValue.copyToClipboard(NSAttributedString(string: vm.outputText))
                            Task {
                                try await Task.sleep(nanoseconds: 200_000_000)
                                copyButtonAnimating = false
                            }
                        } label: {
                            Text("\(Image(systemName: "doc.on.clipboard")) Copy")
                        }
                        .foregroundColor(copyButtonAnimating ? .green : Color(nsColor: .textColor))
                        .animation(.default, value: copyButtonAnimating)
                        .padding(.trailing, 22).padding(.top, 22)
                        .keyboardShortcut("c", modifiers: [.command, .shift])
                        .help("Copy rich text ⌘ ⇧ c")
                    }
            } // <-HSplitView
        } // <-VStack
    }

    var body: some View {
        NavigationLink(destination: myView.navigationTitle(toolPrefixSuffix.navigationTitle),
                       tag: toolPrefixSuffix, selection: $selectedTool) {
            Text(toolPrefixSuffix.sidebarName)
        } // <-NavigationLink
    }
}

// struct PrefixSuffixFinalView_Previews: PreviewProvider {
//    static var previews: some View {
//        PrefixSuffixFinalView()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
