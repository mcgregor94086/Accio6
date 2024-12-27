import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    var onCommit: (() -> Void)?

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .onSubmit {
                    onCommit?()
                }

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(8)
        .background(.quaternary.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
