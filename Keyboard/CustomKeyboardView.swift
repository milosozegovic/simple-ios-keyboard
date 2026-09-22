import KeyboardKit
import SwiftUI

struct CustomKeyboardView: View {

    var services: KeyboardServices

    /// Observed so the layout is rebuilt when the keyboard type changes,
    /// e.g. when 123 switches to the numeric page.
    @ObservedObject var keyboardContext: KeyboardContext

    var body: some View {
        KeyboardView(
            layout: .myLayout(for: keyboardContext),
            services: services,
            buttonContent: { params in
                if let label = pageLabel(for: params.item.action) {
                    Text(label)
                } else {
                    params.view
                }
            },
            buttonView: { $0.view },
            collapsedView: { $0.view },
            emojiKeyboard: { $0.view },
            toolbar: { $0.view }
        )
        .keyboardCalloutActions { params in
            if params.action == .character(".") {
                return Self.periodCallouts
            }
            return params.standardActions()
        }
    }

    /// Long-press alternatives for ".", listed from the key outwards.
    private static let periodCallouts: [KeyboardAction] = ["?", "!", "'", "\""].map { .character($0) }

    private func pageLabel(for action: KeyboardAction) -> String? {
        switch (keyboardContext.keyboardType, action) {
        case (.numeric, .keyboardType(.symbolic)): "1/2"
        case (.symbolic, .keyboardType(.numeric)): "2/2"
        default: nil
        }
    }
}
