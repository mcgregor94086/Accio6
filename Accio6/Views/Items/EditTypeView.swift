import SwiftUI
import SwiftData

/// View for editing the type of an inventory item
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

// MARK: - Preview Provider
#Preview("Edit Type") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let item = InventoryItem(itemName: "Test Item", itemType: .item)
    
    return EditTypeView(item: .constant(item))
        .modelContainer(container)
}
