//
// https://github.com/atacan
// 27.10.22
	

import SwiftUI

struct AnimatingCopyButton: View {
    @Binding var copyButtonAnimating: Bool
    @Binding var outputText: String
    
    var body: some View {
        Button {
            copyButtonAnimating = true
            CopyClient.liveValue.copyToClipboard(NSAttributedString(string: outputText))
            Task {
                try await Task.sleep(nanoseconds: 200_000_000)
                copyButtonAnimating = false
            }
        } label: {
            Text("\(Image(systemName: "doc.on.clipboard")) Copy")
        }
        .foregroundColor(copyButtonAnimating ? .green : Color(nsColor: .textColor))
        .animation(.default, value: copyButtonAnimating)
        .keyboardShortcut("c", modifiers: [.command, .shift])
        .help("Copy rich text ⌘ ⇧ c")
    }
}

//struct AnimatingCopyButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimatingCopyButton()
//    }
//}
