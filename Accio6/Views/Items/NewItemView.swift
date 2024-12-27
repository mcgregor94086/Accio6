import SwiftUI

struct NewItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var itemName = ""
    @State private var itemType: InventoryItemType = .item

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item Name", text: $itemName)
                Picker("Type", selection: $itemType) {
                    Text("Item").tag(InventoryItemType.item)
                    Text("Container").tag(InventoryItemType.container)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addItem()
                        dismiss()
                    }
                }
            }
        }
    }

    private func addItem() {
        let newItem = InventoryItem(
            itemName: itemName,
            itemType: itemType
        )
        modelContext.insert(newItem)
    }
}
