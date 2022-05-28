// https://github.com/atacan/
// 28.05.22
//
    

import SwiftUI

struct ToolsOverView: View {
    @ObservedObject var tools = ToolsModel()
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: threeColumnGrid) {
                ForEach(tools.tools) { tool in
                    ToolsOverviewButtonView(tool: tool)
                } // <-ForEach
            }
            .padding()
        }
    }
}

struct ToolsOverView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsOverView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
