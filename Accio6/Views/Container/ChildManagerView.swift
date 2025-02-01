import SwiftUI
import SwiftData

struct ChildManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [InventoryItem]
    
    let parentID: UUID
    
    init(parentID: UUID) {
        self.parentID = parentID
        self._items = Query(
            filter: #Predicate<InventoryItem> { item in
                item.parentID == parentID
            },
            sort: \InventoryItem.itemName
        )
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    VStack(alignment: .leading) {
                        Text(item.itemName)
                        if !item.tags.isEmpty {
                            Text(item.tags.joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationDestination(for: InventoryItem.self) { item in
            ItemDetailView(item: item)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = InventoryItem(
            itemName: "New Item",
            itemType: .item,
            parentID: parentID
        )
        modelContext.insert(newItem)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    return NavigationStack {
        ChildManagerView(parentID: UUID())
    }
    .modelContainer(container)
}
