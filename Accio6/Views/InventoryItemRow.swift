import SwiftUI
import SwiftData

struct InventoryItemRow: View {
    let item: InventoryItem
    
    var body: some View {
        HStack {
            Image(systemName: item.itemType == .container ? "folder" : "doc")
            VStack(alignment: .leading) {
                Text(item.itemName)
                if !item.tags.isEmpty {
                    Text(item.tags.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if item.itemType == .container {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}

struct InventoryItemRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            InventoryItemRow(item: InventoryItem(
                itemName: "Test Item",
                itemType: .item,
                tags: ["test", "preview"]
            ))
            
            InventoryItemRow(item: InventoryItem(
                itemName: "Test Container",
                itemType: .container,
                tags: ["test", "container"]
            ))
        }
    }
}
