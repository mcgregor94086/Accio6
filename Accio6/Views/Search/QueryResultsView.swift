import SwiftUI
import SwiftData

struct QueryResultsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [InventoryItem]
    
    init(searchText: String) {
        let predicate = PredicateBuilder.buildSearchPredicate(searchText: searchText)
        _items = Query(filter: predicate, sort: \InventoryItem.itemName)
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    ItemRow(item: item)
                }
            }
        }
        .navigationDestination(for: InventoryItem.self) { item in
            if item.itemType == .container {
                InventoryView(parentID: item.id)
                    .navigationTitle(item.itemName)
            } else {
                ItemDetailView(item: item)
            }
        }
    }
}

#Preview {
    NavigationStack {
        QueryResultsView(searchText: "test")
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
