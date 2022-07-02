






import SwiftUI

struct FieldTimestampTriggerView: View {
    @Binding var input: VaporProperty.FluentTimestampTrigger?
    
    var body: some View {
        if input != nil {
        Picker("on", selection: $input) {
            ForEach(VaporProperty.FluentTimestampTrigger.allCases) { trigger in
                Text(trigger.rawValue)
                    .font(.monospaced(.body)())
                    .tag(Optional(trigger))
            }
        }
        .help("timestamp trigger")
    }
        else {
            EmptyView()
        }
    }
}
