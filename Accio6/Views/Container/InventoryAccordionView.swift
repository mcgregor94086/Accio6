import SwiftUI
import SwiftData

struct InventoryAccordionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var containers: [InventoryItem]
    @Query private var items: [InventoryItem]
    
    let container: InventoryItem
    @State private var isExpanded = true
    
    init(container: InventoryItem) {
        let containerId = container.id  // Capture the values we need
        let containerType = ItemType.container
        let itemType = ItemType.item
        
        self.container = container
        
        let containerPredicate = #Predicate<InventoryItem> { item in
            item.parentID == containerId && item.itemType == containerType
        }
        self._containers = Query(filter: containerPredicate, sort: \InventoryItem.itemName)
        
        let itemsPredicate = #Predicate<InventoryItem> { item in
            item.parentID == containerId && item.itemType == itemType
        }
        self._items = Query(filter: itemsPredicate, sort: \InventoryItem.itemName)
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(containers) { container in
                InventoryAccordionView(container: container)
            }
            
            ForEach(items) { item in
                NavigationLink(value: item) {
                    InventoryItemRow(item: item)
                }
            }
            .onDelete(perform: deleteItems)
        } label: {
            HStack {
                Label(container.itemName, systemImage: "folder")
                Spacer()
                Menu {
                    Button {
                        addContainer()
                    } label: {
                        Label("Add Container", systemImage: "folder.badge.plus")
                    }
                    
                    Button {
                        addItem()
                    } label: {
                        Label("Add Item", systemImage: "doc.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
    
    private func addContainer() {
        let newContainer = InventoryItem(
            itemName: "New Container",
            itemType: .container,
            tags: [],
            parentID: container.id
        )
        modelContext.insert(newContainer)
    }
    
    private func addItem() {
        let newItem = InventoryItem(
            itemName: "New Item",
            itemType: .item,
            tags: [],
            parentID: container.id
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
    
    let rootContainer = InventoryItem(
        itemName: "Root",
        itemType: .container,
        tags: ["preview"]
    )
    container.mainContext.insert(rootContainer)
    
    return NavigationStack {
        List {
            InventoryAccordionView(container: rootContainer)
        }
    }
    .modelContainer(container)
}
