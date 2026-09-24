import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    /// Called once on launch. Configure KeyboardKit here.
    override func viewWillSetupKeyboardKit() {
        setupKeyboardKit(for: .simpleKeyboard) { [weak self] result in
            switch result {
            case .success:
                self?.hideToolbar()
                self?.configureHaptics()
            case .failure(let error):
                NSLog("KeyboardKit setup failed: \(error)")
            }
        }
    }

    /// Called whenever the keyboard view needs to be (re)built.
    override func viewWillSetupKeyboardView() {
        // Also here: setup completes asynchronously, and a keyboard launched
        // fresh in another app can build its view before that completion runs.
        hideToolbar()
        configureHaptics()
        setupKeyboardView { controller in
            CustomKeyboardView(
                services: controller.services,
                keyboardContext: controller.state.keyboardContext
            )
        }
    }
}

private extension KeyboardViewController {

    /// KeyboardKit's default is the faint `selectionChanged` on both press and
    /// release. A single light impact on press is closer to the system keyboard.
    func configureHaptics() {
        let haptics = state.feedbackContext.hapticConfiguration
        guard haptics.press != .lightImpact || haptics.release != .none else { return }
        state.feedbackContext.hapticConfiguration.press = .lightImpact
        state.feedbackContext.hapticConfiguration.release = .none
    }

    /// There is no autocomplete, so the suggestion toolbar is dead space.
    func hideToolbar() {
        state.autocompleteContext.settings.isToolbarEnabled = false
    }
}
