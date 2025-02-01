import SwiftUI
import SwiftData

struct ItemRow: View {
    let item: InventoryItem
    
    var body: some View {
        HStack {
            Image(systemName: item.itemType == .container ? "folder" : "doc")
                .foregroundStyle(item.itemType == .container ? .blue : .primary)
            
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
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .background(Color.clear)
    }
}

#Preview {
    List {
        ItemRow(item: InventoryItem(
            itemName: "Test Item",
            itemType: .item,
            tags: ["test", "preview"]
        ))
        
        ItemRow(item: InventoryItem(
            itemName: "Test Container",
            itemType: .container,
            tags: ["test", "container"]
        ))
    }
    .listStyle(.plain)
}
