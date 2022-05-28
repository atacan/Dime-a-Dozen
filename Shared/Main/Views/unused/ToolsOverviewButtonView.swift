// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

struct ToolsOverviewButtonView: View {
    let tool: Tool

    var body: some View {
        Button {
            //
        } label: {
            Text(tool.name)
        } // <-Button
    }
}

struct ToolsOverviewButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsOverviewButtonView(tool: Tool(name: "Mock"))
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
