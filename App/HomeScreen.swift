import SwiftUI

struct HomeScreen: View {

    @State private var text = ""
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

                Section("Setup") {
                    Label("Settings → General → Keyboard → Keyboards", systemImage: "1.circle")
                    Label("Add New Keyboard… → Simple Keyboard", systemImage: "2.circle")
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

#Preview {
    HomeScreen()
}
