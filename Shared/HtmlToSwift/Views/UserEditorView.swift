// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftUI
import MacSwiftUI

struct UserEditorView: View {
    @Binding var text: NSMutableAttributedString
    @Binding var title: String
    @Binding var footNote: String
    @Binding var language: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
            myEditor
            Text(footNote)
                .font(.footnote)
                .padding(.bottom).padding(.horizontal)
        } // <-VStack
    }
}

extension UserEditorView {
    private var myEditor: some View {
        MacEditorView(text: $text)
            .font(.monospaced(.body)())
            .shadow(radius: 2)
            .padding(.horizontal)
    }
}

