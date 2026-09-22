import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    /// Called once on launch. Configure KeyboardKit here.
    override func viewWillSetupKeyboardKit() {
        setupKeyboardKit(for: .simpleKeyboard) { [weak self] result in
            switch result {
            case .success:
                // No autocomplete, so the suggestion toolbar is dead space.
                self?.state.autocompleteContext.settings.isToolbarEnabled = false
            case .failure(let error):
                NSLog("KeyboardKit setup failed: \(error)")
            }
        }
    }

    /// Called whenever the keyboard view needs to be (re)built.
    override func viewWillSetupKeyboardView() {
        setupKeyboardView { controller in
            CustomKeyboardView(
                services: controller.services,
                keyboardContext: controller.state.keyboardContext
            )
        }
    }
}
