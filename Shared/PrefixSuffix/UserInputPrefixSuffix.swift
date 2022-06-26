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
                    TextField("Replace Prefix", text: $prefixReplace)
                    // add prefix
                    TextField("with", text: $prefixReplaceWith)
                    // replace suffix
                } // <-VStack
                TextField("Add Prefix", text: $prefixAdd)
                VStack(alignment: .leading) {
                    TextField("Replace Suffix", text: $suffixReplace)
                    // add suffix
                    TextField("with", text: $suffixReplaceWith)
                } // <-VStack
                TextField("Add Suffix", text: $suffixAdd)
            } // <-HStack
            Toggle("Trim White Space", isOn: $vm.trimWhiteSpace)
            Button {
                vm.convert()
            } label: {
                Text("Convert")
            } // <-Button
        } // <-Form
    }
}

//struct UserInputPrefixSuffix_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInputPrefixSuffix()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
