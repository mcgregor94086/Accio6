import SwiftUI
import SwiftData

struct ItemRow: View {
    let item: InventoryItem
    @Query private var children: [InventoryItem]
    
    init(item: InventoryItem) {
        self.item = item
        let predicate = PredicateHelper.childrenPredicate(parentId: item.id)
        let sortDescriptor = SortDescriptor<InventoryItem>(\.itemName)
        _children = Query(filter: predicate, sort: [sortDescriptor])
    }
    
    var body: some View {
        HStack {
            Image(systemName: item.itemType == .container ? "folder" : "doc")
                .foregroundStyle(item.itemType == .container ? .blue : .gray)
            
            VStack(alignment: .leading) {
                Text(item.itemName)
                if item.itemType == .container && !children.isEmpty {
                    Text("\(children.count) items")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    let container = InventoryItem(itemName: "Test Container", itemType: .container)
    let context = try! ModelContainer(for: InventoryItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)).mainContext
    context.insert(container)
    return ItemRow(item: container)
        .modelContainer(for: InventoryItem.self, inMemory: true)
}
