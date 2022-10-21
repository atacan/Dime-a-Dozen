//
// https://github.com/atacan
// 20.10.22

import ComposableArchitecture
import MacSwiftUI
import SwiftUI

let jsonPrettifyTool = Tool(sidebarName: "Json Pretty", navigationTitle: "Format and highlight json")

struct JsonPrettifier: ReducerProtocol {
    struct State: Equatable {
        @BindableState var input: String = ""
        @BindableState var output: NSAttributedString = .init()
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case convertRequested
        case convertResponse(TaskResult<NSAttributedString>)
        case copyToClipboard
    }

    @Dependency(\.jsonClient) var jsonClient
    @Dependency(\.copyClient) var copyClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .convertRequested:

                return .task { [input = state.input] in
                    await .convertResponse(TaskResult { try await self.jsonClient.convert(input) })
                }
            case let .convertResponse(.success(pretty)):
                state.output = pretty
                return .none
            case let .convertResponse(.failure(error)):
//                let textColor = NSColor.labelColor
                let textColor = NSColor.systemGreen
                let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: NSFont.Weight.regular)]
                let attributedString = NSAttributedString(string: error.localizedDescription, attributes: attributes)

                state.output = attributedString
                return .none
            case .copyToClipboard:
                copyClient.copyToClipboard(state.output)
                return .none
            case .binding:
                return .none
            }
        }
    }
}

let jsonStore = Store(initialState: .init(), reducer: JsonPrettifier()._printChanges())

struct JsonPrettyView: View {
    @Binding var selectedTool: Tool?
    let store: StoreOf<JsonPrettifier>

    var myView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VSplitView {
                VStack {
                    MacEditorControllerView(text: viewStore.binding(\.$input))
                        .shadow(radius: 2)
                        .padding()
                    Button("Prettify") {
                        viewStore.send(.convertRequested)
                    }
                    .padding(.bottom)
                }
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundColor(Color(NSColor.textBackgroundColor))
                    TextWithAttributedString(attributedString: viewStore.output)
                        .padding()

//                        Text(AttributedString(viewStore.output))
                }
                .overlay(alignment: .topTrailing) {
                    Button("Copy") {
                        viewStore.send(.copyToClipboard)
                    }.padding().padding(.trailing).padding(.trailing)
                }
            }
        }
    }

    var body: some View {
        NavigationLink(destination: myView, tag: jsonPrettifyTool, selection: $selectedTool) {
            Text(jsonPrettifyTool.sidebarName)
        } // <-NavigationLink
    }
}

// struct JsonPrettyView_Previews: PreviewProvider {
//    static var previews: some View {
//        JsonPrettyView(store: Store(initialState: .init(), reducer: JsonPrettifier()))
//    }
// }

class ViewWithLabel: NSView {
    private var scrollView = NSScrollView()
    private var label = NSTextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.hasVerticalScroller = true
        label.autoresizingMask = [.height, .width]
        label.isEditable = false
        scrollView.autoresizingMask = [.height, .width]
        scrollView.documentView = label
        addSubview(scrollView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setString(_ attributedString: NSAttributedString) {
        label.textStorage?.setAttributedString(attributedString)
    }
}

struct TextWithAttributedString: NSViewRepresentable {

    var attributedString: NSAttributedString

    func makeNSView(context: Context) -> ViewWithLabel {
        let view = ViewWithLabel(frame: CGRect.zero)
        return view
    }

    func updateNSView(_ uiView: ViewWithLabel, context: NSViewRepresentableContext<TextWithAttributedString>) {
        uiView.setString(attributedString)
    }
}
