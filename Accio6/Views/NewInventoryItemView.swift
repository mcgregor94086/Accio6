import SwiftUI
import SwiftData

struct NewInventoryItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemName = ""
    @State private var itemType: InventoryItemType = .item
    
    var body: some View {
        Form {
            TextField("Name", text: $itemName)
            Picker("Type", selection: $itemType) {
                Text("Item").tag(InventoryItemType.item)
                Text("Container").tag(InventoryItemType.container)
            }
            Button("Create") {
                let newInventoryItem = InventoryItem(
                    itemName: itemName,
                    itemType: itemType
                )
                modelContext.insert(newInventoryItem)
                dismiss()
            }
        }
    }
} 