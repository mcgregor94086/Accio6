import SwiftUI

struct InventoryItemDetail: View {
    @Bindable var inventoryItem: InventoryItem

    var body: some View {
        Form {
            TextField("Name", text: $inventoryItem.itemName)
            // ... rest of the view
        }
    }
}
