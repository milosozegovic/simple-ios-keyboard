import KeyboardKit
import SwiftUI

struct HomeScreen: View {

    @State private var text = ""
    @StateObject private var feedback = KeyboardFeedbackSettings()
    @AppStorage(SharedSettings.showsNumbersRowKey, store: SharedSettings.store) private var showsNumbersRow = true
    @AppStorage(SharedSettings.showsLeftSpaceKeyKey, store: SharedSettings.store) private var showsLeftSpaceKey = true
    @AppStorage(SharedSettings.leftSpaceKeyKey, store: SharedSettings.store) private var leftSpaceKey = SharedSettings.defaultLeftSpaceKey
    @AppStorage(SharedSettings.showsRightSpaceKeyKey, store: SharedSettings.store) private var showsRightSpaceKey = true
    @AppStorage(SharedSettings.rightSpaceKeyKey, store: SharedSettings.store) private var rightSpaceKey = SharedSettings.defaultRightSpaceKey
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Try it") {
                    TextField("Type here…", text: $text, axis: .vertical)
                        .lineLimit(3...)
                        .focused($isFocused)
                    Text("Tap the field, then hold the 🌐 globe key and pick Simple Keyboard.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    Toggle("Numbers row", isOn: $showsNumbersRow)
                    Toggle("Haptic feedback", isOn: $feedback.isHapticFeedbackEnabled)
                    Toggle("Key sounds", isOn: $feedback.isAudioFeedbackEnabled)
                } header: {
                    Text("Keyboard")
                } footer: {
                    Text("These settings need Full Access to reach the keyboard, and apply the next time it appears.")
                }

                Section {
                    Toggle("Key left of space", isOn: $showsLeftSpaceKey)
                    spaceKeyPicker("Left key", selection: $leftSpaceKey)
                        .disabled(!showsLeftSpaceKey)
                    Toggle("Key right of space", isOn: $showsRightSpaceKey)
                    spaceKeyPicker("Right key", selection: $rightSpaceKey)
                        .disabled(!showsRightSpaceKey)
                } header: {
                    Text("Spacebar keys")
                } footer: {
                    Text("Holding \".\" shows ? ! ' and \" wherever the period is.")
                }

                Section("Setup") {
                    Label("Settings → General → Keyboard → Keyboards", systemImage: "1.circle")
                    Label("Add New Keyboard… → Simple Keyboard", systemImage: "2.circle")
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Optional: tap Simple Keyboard → Allow Full Access", systemImage: "3.circle")
                        Text("Needed for haptic feedback, which iOS doesn't allow keyboards without it, and for the Keyboard settings above. Simple Keyboard never sends what you type anywhere.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Button("Open Settings") {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url)
                    }
                }
            }
            .navigationTitle("Simple Keyboard")
            .task { isFocused = true }
        }
    }
}

private extension HomeScreen {

    func spaceKeyPicker(_ title: String, selection: Binding<String>) -> some View {
        Picker(title, selection: selection) {
            ForEach(SharedSettings.spaceKeyOptions, id: \.self) { character in
                Text(character).tag(character)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
