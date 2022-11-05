//
// https://github.com/atacan
// 05.11.22
	

import SwiftUI
import ComposableArchitecture
import MacSwiftUI

let swiftPrettifyTool = Tool(sidebarName: "Swift Pretty", navigationTitle: "Format and highlight Swift Code")

struct SwiftPretty
: ReducerProtocol {
    struct State: Equatable {
        @BindableState var input = NSMutableAttributedString()
        @BindableState var output = NSMutableAttributedString()
        @BindableState var htmlOutput = String(repeating: "testing <html>\n", count: 15)
        var copyButtonAnimating = false
        var saveButtonAnimating = false
        var isSwiftRequestInFlight = false
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case convertRequested
        case convertResponse(TaskResult<SwiftOutput>)
        case copyToClipboard
        case saveAsImage
        case copyButtonAnimationCompleted
        case saveImageButtonAnimationCompleted
        case htmlView
    }

    @Dependency(\.swiftHighlightAsyncClient) var swiftHighlightAsyncClient
    @Dependency(\.stringImageClient) var stringImageClient
    @Dependency(\.copyClient) var copyClient
    @Dependency(\.windowClient) var windowClient
    @Dependency(\.mainQueue) var mainQueue
    private enum SwiftHighlightRequestID {}

    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                //
            case .binding(_):
                return .none
            case .convertRequested:
                state.isSwiftRequestInFlight = true
                return .task { [input = state.input.string] in
                    return await .convertResponse(TaskResult {
                        try await self.swiftHighlightAsyncClient.convert(input)
                        
                    })
                }
                .cancellable(id: SwiftHighlightRequestID.self)
            case let .convertResponse(.success(pretty)):
                state.isSwiftRequestInFlight = false
                state.output = NSMutableAttributedString(attributedString: pretty.attributed)
                state.htmlOutput = pretty.html
                return .none
            case let .convertResponse(.failure(error)):
                state.isSwiftRequestInFlight = false
                let textColor = NSColor.systemGreen
                let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.regular)]
                let attributedString = NSAttributedString(string: error.localizedDescription, attributes: attributes)

                state.output = NSMutableAttributedString(attributedString: attributedString)
                return .none
            case .copyToClipboard:
                state.copyButtonAnimating = true
                copyClient.copyToClipboard(state.output)
                return .task {
                    try await self.mainQueue.sleep(for: .milliseconds(200))
                    return .copyButtonAnimationCompleted
                }
            case .copyButtonAnimationCompleted:
                state.copyButtonAnimating = false
                return .none
            case .saveAsImage:
                return .task { [output = state.output] in
                    await stringImageClient.save(output)
                    return .saveImageButtonAnimationCompleted
                }
            case .saveImageButtonAnimationCompleted:
                state.saveButtonAnimating = false
                return .none
            case .htmlView:
                windowClient.show(HtmlView(text: state.htmlOutput))
                return .none
            }
        }
    }
}

let swiftStore = Store(initialState: .init(), reducer: SwiftPretty())

struct SwiftPrettyView: View {
    @Binding var selectedTool: Tool?
    let store: StoreOf<SwiftPretty>

    var myView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VSplitView {
                VStack {
                    MacEditorView(text: viewStore.binding(\.$input))
                        .shadow(radius: 2)
                        .padding()
                    
                    Button(action: {
                        viewStore.send(.convertRequested)
                    }, label: {
                        HStack {
                            Text("Prettify")
                            if viewStore.isSwiftRequestInFlight {
                                MacProgressSpinner()
                            }
                        }
                    })
                    .padding(.bottom)
                    .keyboardShortcut(.return, modifiers: .command)
                    .help("Format and highliht ⌘ + ↵")
                }
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundColor(Color(NSColor.textBackgroundColor))
//                    TextWithAttributedString(attributedString: viewStore.output)
                    MacEditorView(text: viewStore.binding(\.$output))
                        .padding()
                        .colorScheme(.dark)

//                        Text(AttributedString(viewStore.output))
                }
                .overlay(alignment: .topTrailing) {
                    VStack(alignment: .trailing) {
                        HStack {
                            Button {
                                viewStore.send(.copyToClipboard)
                            } label: {
                                Text("\(Image(systemName: "doc.on.clipboard")) Copy")
                                    
                            }
                            .foregroundColor(viewStore.copyButtonAnimating ? .green : Color(nsColor: .textColor))
                            .keyboardShortcut("c", modifiers: [.command, .shift])
                            .help("Copy rich text ⌘ ⇧ c")
                            .animation(.default, value: viewStore.copyButtonAnimating)
                            
                            Button {
                                viewStore.send(.saveAsImage)
                            } label: {
                                Text("\(Image(systemName: "text.below.photo")) as png")
                                    
                            }
                            .foregroundColor(viewStore.copyButtonAnimating ? .green : Color(nsColor: .textColor))
                            .keyboardShortcut("s", modifiers: [.command, .shift])
                            .help("Copy rich text ⌘ ⇧ c")
                            .animation(.default, value: viewStore.copyButtonAnimating)
                        }
                        Button {
                            viewStore.send(.htmlView)
                        } label: {
                            Text("<html>")
                        }

                    }
                    .padding(.trailing, 18).padding().padding(.top, 8)
                }
            }
            .onReceive(topMenu.copyOutputCommand) { _ in
                viewStore.send(.copyToClipboard)
            }
        }
    }

    var body: some View {
        NavigationLink(destination: myView, tag: swiftPrettifyTool, selection: $selectedTool) {
            Text(swiftPrettifyTool.sidebarName)
        } // <-NavigationLink
    }
}

struct HtmlView: View {
    let text: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(nsColor: .textBackgroundColor))
                Text(text)
                    .font(.monospaced(.body)())
                    .textSelection(.enabled)
                    .padding()
            } // <-ZStack
        } // <-ScrollView
    }
}
