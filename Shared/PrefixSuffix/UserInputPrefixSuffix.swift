//
// https://github.com/atacan
// 25.06.22

import SwiftUI

struct UserInputPrefixSuffix: View {
    @ObservedObject var vm: PrefixSuffixModel
    @Binding var prefixReplace: String
    @Binding var prefixReplaceWith: String
    @Binding var prefixAdd: String
    @Binding var suffixReplace: String
    @Binding var suffixReplaceWith: String
    @Binding var suffixAdd: String
    @Binding var trimWhiteSpace: Bool

    var body: some View {
        Form {
            HStack(alignment: .center) {
                // replace prefix
                VStack(alignment: .leading) {
                    TextField(text: $prefixReplace) {
                        Text("Replace Prefix")
                            .font(.body)
                    }
                    .font(.monospaced(.body)())
                    TextField(text: $prefixReplaceWith) {
                        Text("with")
                            .font(.body)
                    }
                    .font(.monospaced(.body)())
                } // <-VStack
                // add prefix
                TextField(text: $prefixAdd) {
                    Text("Add Prefix")
                        .font(.body)
                }
                .font(.monospaced(.body)())
                // replace suffix
                VStack(alignment: .leading) {
                    TextField(text: $suffixReplace) {
                        Text("Replace Suffix")
                            .font(.body)
                    }
                    .font(.monospaced(.body)())
                    TextField(text: $suffixReplaceWith) {
                        Text("with")
                            .font(.body)
                    }
                    .font(.monospaced(.body)())
                } // <-VStack
                // add suffix
                TextField(text: $suffixAdd) {
                    Text("Add Suffix")
                        .font(.body)
                }
                .font(.monospaced(.body)())
            } // <-HStack
            Toggle("Trim White Space", isOn: $vm.trimWhiteSpace)
            Button {
                vm.convert()
            } label: {
                Text("\(Image(systemName: "arrow.turn.down.right")) Convert \(Image(systemName: "arrow.forward"))")
            } // <-Button
            Text("")
        } // <-Form
    }
}

// struct UserInputPrefixSuffix_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInputPrefixSuffix()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
