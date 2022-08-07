//
// https://github.com/atacan
// 07.08.22
	

import SwiftUI

#if os(macOS)
import MacSwiftUI
struct TextViewMultiPlatform: View {
    @Binding var text: String
    var body: some View {
        MacEditorControllerView(text: $text)
            .font(.monospaced(.body)())
            .shadow(radius: 2)
            .padding(.horizontal)
    }
}
#elseif os(iOS)
struct TextViewMultiPlatform: View {
    @Binding var text: String
    var body: some View {
        TextEditor(text: $text)
            .font(.monospaced(.body)())
            .shadow(radius: 2)
            .padding(.horizontal)
    }
}
#endif
