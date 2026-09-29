import KeyboardKit

extension KeyboardApp {

    /// Shared configuration used by both the app and the keyboard extension.
    ///
    /// The App Group syncs settings, like the feedback toggles, between the
    /// app and the keyboard. The keyboard can only read it with Full Access.
    /// A `licenseKey:` here unlocks KeyboardKit Pro.
    static var simpleKeyboard: KeyboardApp {
        .init(name: "Simple Keyboard", appGroupId: SharedSettings.appGroupId)
    }
}
