import KeyboardKit
import SwiftUI

struct CustomKeyboardView: View {

    var services: KeyboardServices
    var state: KeyboardState

    var body: some View {
        KeyboardView(
            layout: .myLayout(for: state.keyboardContext),
            services: services,
            buttonContent: { $0.view },
            buttonView: { $0.view },
            collapsedView: { $0.view },
            emojiKeyboard: { $0.view },
            toolbar: { $0.view }
        )
    }
}
