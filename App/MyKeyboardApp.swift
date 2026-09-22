import KeyboardKit
import SwiftUI

@main
struct MyKeyboardApp: App {

    var body: some Scene {
        WindowGroup {
            KeyboardAppView(for: .myKeyboard) {
                HomeScreen()
            }
        }
    }
}
