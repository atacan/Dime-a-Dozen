// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct ComingSoonView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Coming soon...")
                .font(.title)
            Text("Fork it and add the boilerplate generation tools you need:")
                .font(.title3)
            Text("https://github.com/atacan/Dime-a-Dozen")
                .font(.body)
        } // <-VStack
    }
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
