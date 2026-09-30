import Combine
import KeyboardKit
import SwiftUI

class KeyboardViewController: KeyboardInputViewController {

    /// Space above the top row of keys.
    private static let topGap: CGFloat = 16

    private var heightConstraint: NSLayoutConstraint?
    private var keyboardTypeObservation: AnyCancellable?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Before the first layout, so iOS never sees an interim height.
        updateHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeight()
    }

    override func viewWillLayoutSubviews() {
        updateHeight()
        super.viewWillLayoutSubviews()
    }

    /// Called whenever the keyboard view needs to be (re)built.
    override func viewWillSetupKeyboardView() {
        // Also here: setup completes asynchronously, and a keyboard launched
        // fresh in another app can build its view before that completion runs.
        hideToolbar()
        configureHaptics()
        keyboardTypeObservation = state.keyboardContext.$keyboardType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.updateHeight() }
        setupKeyboardView { controller in
            CustomKeyboardView(
                services: controller.services,
                keyboardContext: controller.state.keyboardContext,
                calloutContext: controller.state.calloutContext
            )
        }
    }
}

private extension KeyboardViewController {

    /// Left to itself, iOS measures the keyboard's height from its SwiftUI view,
    /// and that measurement races on launch: the top edge sometimes lands right
    /// on the first row and sometimes higher. A fixed height, with the keys
    /// pinned to the bottom, keeps the gap the same every time.
    func updateHeight() {
        let height = KeyboardLayout.myLayout(for: state.keyboardContext).keyboardHeight(topGap: Self.topGap)
        if let heightConstraint {
            if heightConstraint.constant != height { heightConstraint.constant = height }
            return
        }
        let constraint = view.heightAnchor.constraint(equalToConstant: height)
        constraint.priority = .required - 1
        constraint.isActive = true
        heightConstraint = constraint
    }


    /// KeyboardKit's default is the faint `selectionChanged` on both press and
    /// release. A single press haptic, played by SimpleFeedbackService, is closer
    /// to the system keyboard.
    func configureHaptics() {
        if !(services.feedbackService is SimpleFeedbackService) {
            let service = SimpleFeedbackService()
            services.feedbackService = service
            (services.actionHandler as? StandardKeyboardActionHandler)?.feedbackService = service
        }
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
