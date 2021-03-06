//
//  View.swift
//  DimeADozen
//
//  Created by atacan on 04.06.22.
//

import SwiftUI

struct PatternInputView: View {
    @ObservedObject var regexVM: RegexViewModel
    @Binding var pattern: String

    var body: some View {
        HStack {
            Spacer()
            TextField("Regex pattern", text: $pattern)
                .font(.monospaced(.body)())
                .onSubmit {
                    regexVM.regexMatches(of: pattern)
                }
            Button {
                regexVM.regexMatches(of: pattern)
            } label: {
                Text("Extract")
            } // <-Button
            Spacer()
        }
    }
}

// struct PatternInputView_Previews: PreviewProvider {
//    static var previews: some View {
//        PatternInputView()
//            .preferredColorScheme(.light)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
// }
