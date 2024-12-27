import SwiftUI

struct InventoryItemRow: View {
    let inventoryItem: InventoryItem

    var body: some View {
        HStack {
            Text(inventoryItem.itemName)
            if inventoryItem.itemType == .container {
                Image(systemName: "folder")
            }
        }
    }
}
