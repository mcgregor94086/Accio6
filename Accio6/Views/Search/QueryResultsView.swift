import SwiftUI
import SwiftData

struct QueryResultsView: View {
    @Environment(\.modelContext) private var modelContext
    let searchText: String
    @Query private var allItems: [InventoryItem]
    
    init(searchText: String) {
        self.searchText = searchText
        _allItems = Query(sort: \InventoryItem.itemName)
    }
    
    var matchingItems: [InventoryItem] {
        if searchText.isEmpty {
            return []
        }
        
        return allItems.filter { item in
            // Check item name
            if item.itemName.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            
            // Check tags
            if item.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) }) {
                return true
            }
            
            return false
        }
    }
    
    var body: some View {
        List {
            ForEach(matchingItems) { item in
                NavigationLink {
                    if item.itemType == .container {
                        ContainerView(container: item)
                    } else {
                        ItemDetailView(item: item)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: item.itemType == .container ? "folder" : "doc")
                                .foregroundStyle(item.itemType == .container ? .blue : .gray)
                            Text(item.itemName)
                                .font(.headline)
                        }
                        
                        if !item.tags.isEmpty {
                            Text(item.tags.joined(separator: ", "))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let parentID = item.parentID,
                           let parent = try? modelContext.fetch(
                            FetchDescriptor<InventoryItem>(
                                predicate: PredicateHelper.basicParentPredicate(parentId: parentID)
                            )
                           ).first {
                            Text("In: \(parent.itemName)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .overlay {
            if searchText.isEmpty {
                ContentUnavailableView.search
            } else if matchingItems.isEmpty {
                ContentUnavailableView(
                    "No Results",
                    systemImage: "magnifyingglass",
                    description: Text("Try searching for something else")
                )
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    // Add some sample items
    let context = container.mainContext
    let item1 = InventoryItem(itemName: "Test Item")
    item1.tags = ["test", "sample"]
    let item2 = InventoryItem(itemName: "Another Item", itemType: .container)
    item2.tags = ["container", "test"]
    context.insert(item1)
    context.insert(item2)
    
    return NavigationStack {
        QueryResultsView(searchText: "test")
    }
    .modelContainer(container)
}
