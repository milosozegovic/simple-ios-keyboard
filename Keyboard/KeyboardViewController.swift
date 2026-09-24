import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    /// Called once on launch. Configure KeyboardKit here.
    override func viewWillSetupKeyboardKit() {
        setupKeyboardKit(for: .simpleKeyboard) { [weak self] result in
            switch result {
            case .success:
                self?.hideToolbar()
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
        setupKeyboardView { controller in
            CustomKeyboardView(
                services: controller.services,
                keyboardContext: controller.state.keyboardContext
            )
        }
    }
}

private extension KeyboardViewController {

    /// There is no autocomplete, so the suggestion toolbar is dead space.
    func hideToolbar() {
        state.autocompleteContext.settings.isToolbarEnabled = false
    }
}
