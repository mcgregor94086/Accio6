import SwiftUI
import SwiftData

struct EditTypeView: View {
    @Binding var item: InventoryItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type", selection: $item.itemType) {
                    Text("Container").tag(InventoryItemType.container)
                    Text("Item").tag(InventoryItemType.item)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("Edit Type")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}
