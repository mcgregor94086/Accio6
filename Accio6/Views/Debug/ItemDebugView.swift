import SwiftUI
import SwiftData

struct ItemDebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [InventoryItem]
    
    init() {
        _items = Query(sort: \InventoryItem.itemName)
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    InventoryItemDebugView(item: item)
                } label: {
                    VStack(alignment: .leading) {
                        Text(item.itemName)
                        
                        Group {
                            if let parentID = item.parentID {
                                Text("Parent: \(parentID.uuidString)")
                            } else {
                                Text("Root Item")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Debug Items")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = InventoryItem(
                itemName: "New Item \(items.count + 1)",
                itemType: .item
            )
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDebugView()
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
