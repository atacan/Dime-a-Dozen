// https://github.com/atacan/
// 28.05.22
//

import SwiftUI

@main
struct DimeADozenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: CommandGroupPlacement.sidebar) {
                ToggleSidebarButton()
                    .keyboardShortcut("l", modifiers: [.command, .shift])
            }
        }
    }
}
