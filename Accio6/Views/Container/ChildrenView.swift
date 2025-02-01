import SwiftUI
import SwiftData

struct ChildrenView: View {
    let container: InventoryItem
    @Query private var children: [InventoryItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddItem = false
    @State private var showingItemDetail: InventoryItem?
    @State private var errorMessage: String?
    @State private var showingError = false
    
    init(container: InventoryItem) {
        self.container = container
        let predicate = PredicateBuilder.childrenPredicate(parentID: container.id)
        _children = Query(filter: predicate, sort: \InventoryItem.itemName)
    }
    
    var body: some View {
        List {
            ForEach(children) { item in
                NavigationLink(value: item) {
                    ItemRow(item: item)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle(container.itemName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddItem = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddItem) {
            NewItemEditorView(parentID: container.id)
        }
        .sheet(item: $showingItemDetail) { item in
            ItemDetailView(item: item)
        }
        .navigationDestination(for: InventoryItem.self) { item in
            if item.itemType == .container {
                ChildrenView(container: item)
            } else {
                ItemDetailView(item: item)
            }
        }
        .alert("Error", isPresented: $showingError, presenting: errorMessage) { _ in
            Button("OK") { }
        } message: { message in
            Text(message)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = children[index]
            do {
                try deleteItemAndChildren(item)
            } catch {
                errorMessage = "Failed to delete item: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
    
    private func deleteItemAndChildren(_ item: InventoryItem) throws {
        let descriptor = FetchDescriptor<InventoryItem>(
            predicate: PredicateBuilder.childrenPredicate(parentID: item.id)
        )
        
        if let children = try? modelContext.fetch(descriptor) {
            for child in children {
                try deleteItemAndChildren(child)
            }
        }
        
        modelContext.delete(item)
        try modelContext.save()
    }
}

#Preview {
    NavigationStack {
        ChildrenView(container: InventoryItem(
            itemName: "Test Container",
            itemType: .container,
            tags: ["test"]
        ))
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
