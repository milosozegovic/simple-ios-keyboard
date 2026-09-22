import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    /// Called once on launch. Configure KeyboardKit here.
    override func viewWillSetupKeyboardKit() {
        setupKeyboardKit(for: .myKeyboard) { result in
            if case .failure(let error) = result {
                NSLog("KeyboardKit setup failed: \(error)")
            }
        }
    }

    /// Called whenever the keyboard view needs to be (re)built.
    override func viewWillSetupKeyboardView() {
        setupKeyboardView { controller in
            CustomKeyboardView(
                services: controller.services,
                state: controller.state
            )
        }
    }
}
