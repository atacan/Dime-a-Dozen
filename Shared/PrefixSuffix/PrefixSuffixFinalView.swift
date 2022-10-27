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
                        AnimatingCopyButton(copyButtonAnimating: $copyButtonAnimating, outputText: $vm.outputText)
                            .padding(.trailing, 22).padding(.top, 22)
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
