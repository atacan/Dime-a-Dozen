//
// https://github.com/atacan
// 26.06.22
	
import SwiftUI

private extension Bool {
    mutating func toggleIfFalse() {
        if !self {
            toggle()
        }
    }
}

struct PoppedButton: View {
    @State private var isVisible: Bool = false
    var body: some View {
        Button("Save to Files") {
            isVisible.toggleIfFalse()
        }
        .popover(isPresented: $isVisible) {
            Text("Coming soon...")
                .padding()
        }
//        .popover(isPresented: $isVisible, attachmentAnchor: PopoverAttachmentAnchor.point(UnitPoint.top), arrowEdge: Edge.bottom, content: {
//            Text("Coming soon...")
//                .padding()
//        })
//        .background(NSPopoverHolderView(isVisible: $isVisible) {
//            Text("Coming soon...")
//                .padding()
//        })
    }
}

struct NSPopoverHolderView<T: View>: NSViewRepresentable {
    @Binding var isVisible: Bool
    var content: () -> T
    
    func makeNSView(context: Context) -> NSView {
        NSView()
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.setVisible(isVisible, in: nsView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(state: _isVisible, content: content)
    }
    
    class Coordinator: NSObject, NSPopoverDelegate {
        private let popover: NSPopover
        private let state: Binding<Bool>
        
        init<V: View>(state: Binding<Bool>, content: @escaping () -> V) {
            self.popover = NSPopover()
            self.state = state
            
            super.init()
            
            popover.delegate = self
            popover.contentViewController = NSHostingController(rootView: content())
            popover.behavior = .transient
        }
        
        func setVisible(_ isVisible: Bool, in view: NSView) {
            if isVisible {
                popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
            } else {
                popover.close()
            }
        }
        
        func popoverDidClose(_ notification: Notification) {
            state.wrappedValue = false
        }
        
        func popoverShouldDetach(_ popover: NSPopover) -> Bool {
            false
        }
    }
}
