import SwiftUI
import SwiftData

@Observable
class ContainerViewModel {
    private let modelContext: ModelContext
    private(set) var container: InventoryItem
    private(set) var children: [InventoryItem] = []
    private(set) var ancestors: [InventoryItem] = []
    
    init(container: InventoryItem, modelContext: ModelContext) {
        self.container = container
        self.modelContext = modelContext
        refreshData()
    }
    
    func refreshData() {
        // Fetch children
        if let containerID = container.id {
            let childrenDescriptor = FetchDescriptor<InventoryItem>(
                predicate: PredicateBuilder.childrenPredicate(parentID: containerID)
            )
            children = (try? modelContext.fetch(childrenDescriptor)) ?? []
        }
        
        // Build ancestor chain
        ancestors = []
        var currentParentID = container.parentID
        
        while let parentID = currentParentID {
            let parentDescriptor = FetchDescriptor<InventoryItem>(
                predicate: PredicateBuilder.parentPredicate(childID: parentID)
            )
            
            if let parent = try? modelContext.fetch(parentDescriptor).first {
                ancestors.append(parent)
                currentParentID = parent.parentID
            } else {
                currentParentID = nil
            }
        }
    }
    
    func addItem(_ item: InventoryItem) {
        if let containerID = container.id {
            item.parentID = containerID
            modelContext.insert(item)
            try? modelContext.save()
            refreshData()
        }
    }
    
    func deleteItem(_ item: InventoryItem) {
        modelContext.delete(item)
        try? modelContext.save()
        refreshData()
    }
    
    func moveItem(_ item: InventoryItem, to newParentID: UUID?) {
        item.parentID = newParentID
        try? modelContext.save()
        refreshData()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let context = container.mainContext
    
    let testContainer = InventoryItem(
        itemName: "Test Container",
        itemType: .container,
        tags: ["test"]
    )
    context.insert(testContainer)
    
    return Text("ContainerViewModel Preview")
        .modelContainer(container)
}
