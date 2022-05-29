// https://github.com/atacan/
// 28.05.22
//

import HtmlSwift
import SwiftUI

struct UserEditorView: View {
    @Binding var text: String
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
        TextEditor(text: $text)
            .font(.monospaced(.body)())
            .padding(.horizontal)
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditorView(text: .constant("type or paste HTML code"), title: .constant("HTML Input"), footNote: .constant("Enclose the whole code inside one tag"), language: .constant("html"))
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
}
