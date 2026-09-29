import Foundation

/// Settings the app writes and the keyboard reads, through the App Group.
///
/// The keyboard can only read the App Group with Full Access. Without it,
/// every setting falls back to its default.
enum SharedSettings {

    static let appGroupId = "group.com.imaginaroom.simple-keyboard"

    static let store = UserDefaults(suiteName: appGroupId) ?? .standard

    static let showsNumbersRowKey = "showsNumbersRow"

    static var showsNumbersRow: Bool {
        store.object(forKey: showsNumbersRowKey) as? Bool ?? true
    }

    static let showsLeftSpaceKeyKey = "showsLeftSpaceKey"
    static let leftSpaceKeyKey = "leftSpaceKey"
    static let showsRightSpaceKeyKey = "showsRightSpaceKey"
    static let rightSpaceKeyKey = "rightSpaceKey"

    static let defaultLeftSpaceKey = ","
    static let defaultRightSpaceKey = "."

    /// The characters offered for the keys beside the spacebar.
    static let spaceKeyOptions = [",", ".", "?", "!", "'", "\"", "-", "/", "@", ":", ";"]

    /// The key left of the spacebar, or nil when it's turned off.
    static var leftSpaceKey: String? {
        spaceKey(shows: showsLeftSpaceKeyKey, character: leftSpaceKeyKey, default: defaultLeftSpaceKey)
    }

    /// The key right of the spacebar, or nil when it's turned off.
    static var rightSpaceKey: String? {
        spaceKey(shows: showsRightSpaceKeyKey, character: rightSpaceKeyKey, default: defaultRightSpaceKey)
    }

    private static func spaceKey(shows: String, character: String, default fallback: String) -> String? {
        guard store.object(forKey: shows) as? Bool ?? true else { return nil }
        let value = store.string(forKey: character) ?? fallback
        return value.isEmpty ? fallback : value
    }
}
