import SwiftUI
import SwiftData

struct InventoryItemList: View {
    let items: [InventoryItem]
    let onDelete: ((IndexSet) -> Void)?
    
    init(items: [InventoryItem], onDelete: ((IndexSet) -> Void)? = nil) {
        self.items = items
        self.onDelete = onDelete
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    InventoryItemRow(item: item)
                }
            }
            .onDelete(perform: onDelete)
        }
        .navigationDestination(for: InventoryItem.self) { item in
            ItemDetailView(item: item)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    let items = [
        InventoryItem(itemName: "Test Item", itemType: .item, tags: ["test"]),
        InventoryItem(itemName: "Test Container", itemType: .container, tags: ["test"])
    ]
    
    for item in items {
        container.mainContext.insert(item)
    }
    
    return NavigationStack {
        InventoryItemList(items: items)
    }
    .modelContainer(container)
}
