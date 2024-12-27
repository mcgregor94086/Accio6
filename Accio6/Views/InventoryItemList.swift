import SwiftUI
import SwiftData

struct InventoryItemList: View {
    @Query private var inventoryItems: [InventoryItem]
    
    var body: some View {
        List {
            ForEach(inventoryItems) { inventoryItem in
                InventoryItemRow(inventoryItem: inventoryItem)
            }
        }
    }
} 