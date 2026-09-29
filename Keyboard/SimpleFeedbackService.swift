import KeyboardKit
import UIKit

/// Plays key presses a little firmer than KeyboardKit's `lightImpact`.
///
/// iOS has no finer step between the light and medium impact styles, so the
/// press uses the medium style at reduced intensity. Raise or lower
/// `pressIntensity` (0...1) to tune it.
final class SimpleFeedbackService: StandardKeyboardFeedbackService {

    private static let pressIntensity: CGFloat = 0.6

    private let pressGenerator = UIImpactFeedbackGenerator(style: .medium)

    override func triggerHapticFeedback(_ feedback: KeyboardHapticFeedback) {
        guard feedback == .lightImpact else { return super.triggerHapticFeedback(feedback) }
        pressGenerator.impactOccurred(intensity: Self.pressIntensity)
        pressGenerator.prepare()
    }
}
