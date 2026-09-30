import KeyboardKit
import SwiftUI

struct CustomKeyboardView: View {

    var services: KeyboardServices

    /// Observed so the layout is rebuilt when the keyboard type changes,
    /// e.g. when 123 switches to the numeric page.
    @ObservedObject var keyboardContext: KeyboardContext

    /// Observed to know which key is showing its tap preview.
    @ObservedObject var calloutContext: KeyboardCalloutContext

    var body: some View {
        let layout = KeyboardLayout.myLayout(for: keyboardContext)
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            KeyboardView(
                layout: layout,
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
                toolbar: { _ in EmptyView() }
            )
            .keyboardToolbarStyle(.init(height: 0, minHeight: 0, maxHeight: 0))
            .keyboardCalloutStyle(calloutStyle(for: layout))
        }
        .keyboardCalloutActions { params in
            guard case .character(let character) = params.action else {
                return params.standardActions()
            }
            if character == "." {
                return Self.periodCallouts
            }
            if let letters = Self.letterCallouts[character.lowercased()] {
                return Self.callouts(
                    prioritizing: letters,
                    standard: params.standardActions() ?? [],
                    isUppercase: params.context.keyboardCase.isUppercasedOrCapslocked
                        || character != character.lowercased()
                )
            }
            return params.standardActions()
        }
    }

    /// Long-press alternatives for ".", listed from the key outwards.
    private static let periodCallouts: [KeyboardAction] = ["?", "!", "'", "\""].map { .character($0) }

    /// Long-press alternatives for letters, in lowercase and listed from the
    /// key outwards. They go right after the plain letter, ahead of
    /// KeyboardKit's standard accents for the key.
    private static let letterCallouts: [String: [String]] = [
        "s": ["š"],
        "c": ["ć", "č"],
        "d": ["đ"],
        "z": ["ž"],
    ]

    /// The standard list starts with the plain letter, which stays first so
    /// a long press released without sliding still types it.
    private static func callouts(
        prioritizing letters: [String],
        standard: [KeyboardAction],
        isUppercase: Bool
    ) -> [KeyboardAction] {
        let preferred = letters.map { KeyboardAction.character(isUppercase ? $0.uppercased() : $0) }
        guard let plain = standard.first else { return preferred }
        let others = standard.dropFirst().filter { !preferred.contains($0) }
        return [plain] + preferred + others
    }

    /// A keyboard can't draw above its own top edge, so the tap preview on the
    /// top row would be cut in half. It's hidden there instead; the key still
    /// shows its pressed state. Long-press menus keep the standard style.
    private func calloutStyle(for layout: KeyboardLayout) -> KeyboardCalloutStyle {
        guard let action = calloutContext.inputAction,
              calloutContext.secondaryActions.isEmpty,
              layout.itemRows.first?.contains(where: { $0.action == action }) == true
        else { return .standard }
        var hidden = KeyboardCalloutStyle.standard
        hidden.backgroundColor = .clear
        hidden.foregroundColor = .clear
        hidden.borderColor = .clear
        hidden.shadowColor = .clear
        return hidden
    }

    private func pageLabel(for action: KeyboardAction) -> String? {
        switch (keyboardContext.keyboardType, action) {
        case (.numeric, .keyboardType(.symbolic)): "1/2"
        case (.symbolic, .keyboardType(.numeric)): "2/2"
        default: nil
        }
    }
}
