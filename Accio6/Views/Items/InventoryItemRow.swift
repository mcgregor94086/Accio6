import SwiftUI

struct InventoryItemRow: View {
    let inventoryItem: InventoryItem

    var body: some View {
        HStack {
            Image(systemName: inventoryItem.itemType.icon)
                .foregroundStyle(inventoryItem.itemType.iconColor)
            Text(inventoryItem.itemName)
        }
    }
}

#Preview {
    let item = InventoryItem(itemName: "Test Item")
    return InventoryItemRow(inventoryItem: item)
} 