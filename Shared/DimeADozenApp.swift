// https://github.com/atacan/
// 28.05.22
//

import SwiftUI
import Combine

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
            CommandGroup(after: CommandGroupPlacement.textEditing) {
                Button("Copy Output", action: {
                    topMenu.copyOutputCommand.send()
                })
                .keyboardShortcut("c", modifiers: [.command, .shift])
            }
        }
    }
}


class TopMenu: ObservableObject {
    var copyOutputCommand = PassthroughSubject<Void,Never>()
}

let topMenu = TopMenu()
