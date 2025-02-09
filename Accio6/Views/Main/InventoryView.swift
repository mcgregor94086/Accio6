import SwiftUI
import SwiftData

struct InventoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var rootItems: [InventoryItem]
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var expandedItems: Set<UUID> = []
    @State private var selectedParent: UUID?
    
    init(parentID: UUID?) {
        print("InventoryView init with parentID: \(String(describing: parentID))")
        let predicate = PredicateBuilder.childrenPredicate(parentID: parentID)
        let sortDescriptor = SortDescriptor<InventoryItem>(\.itemName)
        _rootItems = Query(filter: predicate, sort: [sortDescriptor])
    }
    
    var body: some View {
        List {
            ForEach(rootItems) { item in
                if item.itemType == .container {
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedItems.contains(item.id ?? UUID()) },
                            set: { isExpanded in
                                if isExpanded {
                                    expandedItems.insert(item.id ?? UUID())
                                } else {
                                    expandedItems.remove(item.id ?? UUID())
                                }
                            }
                        )
                    ) {
                        InventoryView(parentID: item.id)
                            .padding(.leading, -20)
                    } label: {
                        ItemRow(item: item)
                            .padding(.leading, -20)
                    }
                } else {
                    ItemRow(item: item)
                        .padding(.leading, -20)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .onAppear {
            print("InventoryView appeared with \(rootItems.count) items:")
            for item in rootItems {
                print("- \(item.itemName) (Type: \(item.itemType), ParentID: \(String(describing: item.parentID)))")
            }
        }
        .alert("Error", isPresented: $showingError, presenting: errorMessage) { _ in
            Button("OK") { }
        } message: { message in
            Text(message)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let item = rootItems[index]
                do {
                    try deleteItemAndChildren(item)
                } catch {
                    errorMessage = "Failed to delete item: \(error.localizedDescription)"
                    showingError = true
                }
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

struct ContainerDetailView: View {
    let container: InventoryItem
    @State private var showingAddItem = false
    @State private var showingItemDetail: InventoryItem?
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        InventoryView(parentID: container.id)
            .navigationTitle(container.itemName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                    ContainerDetailView(container: item)
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
}

#Preview {
    NavigationStack {
        InventoryView(parentID: nil)
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
