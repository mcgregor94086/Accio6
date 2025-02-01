import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [InventoryItem]
    @State private var selectedItem: InventoryItem?
    
    init() {
        let predicate = PredicateBuilder.childrenPredicate(parentID: nil)
        _items = Query(filter: predicate, sort: \InventoryItem.itemName)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        ItemRow(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                    .background(
                        NavigationLink(value: item, label: { EmptyView() })
                            .opacity(0)
                    )
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("Inventory")
            .navigationDestination(for: InventoryItem.self) { item in
                if item.itemType == .container {
                    InventoryView(parentID: item.id)
                        .navigationTitle(item.itemName)
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                NavigationLink(value: item.id) {
                                    Label("Add Item", systemImage: "plus")
                                }
                            }
                        }
                } else {
                    ItemDetailView(item: item)
                }
            }
            .navigationDestination(for: UUID.self) { id in
                NewItemEditorView(parentID: id)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(value: UUID()) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: InventoryItem.self, inMemory: true)
}
