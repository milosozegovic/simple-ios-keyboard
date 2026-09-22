import KeyboardKit

extension KeyboardApp {

    /// Shared configuration used by both the app and the keyboard extension.
    ///
    /// To sync settings between the two, create an App Group in the Apple
    /// Developer portal, add it to both targets, then pass its id here as
    /// `appGroupId:`. A `licenseKey:` here unlocks KeyboardKit Pro.
    static var simpleKeyboard: KeyboardApp {
        .init(name: "Simple Keyboard")
    }
}
