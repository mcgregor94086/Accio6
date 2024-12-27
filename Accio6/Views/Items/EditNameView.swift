import SwiftUI
import SwiftData

struct EditNameView: View {
    @Binding var item: InventoryItem
    @Environment(\.dismiss) private var dismiss

    @State private var name: String

    init(item: Binding<InventoryItem>) {
        self._item = item
        self._name = State(initialValue: item.wrappedValue.itemName)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
            }
            .navigationTitle("Edit Name")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        item.itemName = name
                        dismiss()
                    }
                }
            }
        }
    }
}
