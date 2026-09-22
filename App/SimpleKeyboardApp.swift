import KeyboardKit
import SwiftUI

@main
struct SimpleKeyboardApp: App {

    var body: some Scene {
        WindowGroup {
            KeyboardAppView(for: .simpleKeyboard) {
                HomeScreen()
            }
        }
    }
}
