import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<InventoryItem> { $0.parentID == nil },
           sort: \InventoryItem.itemName) private var rootItems: [InventoryItem]
    
    @State private var showingAddItem = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationSplitView {
            List {
                if rootItems.isEmpty {
                    ContentUnavailableView(
                        "No Items",
                        systemImage: "square.dashed",
                        description: Text("Add items using the + button")
                    )
                } else {
                    ForEach(rootItems) { item in
                        NavigationLink {
                            if item.itemType == .container {
                                ContainerView(container: item)
                            } else {
                                ItemDetailView(item: item)
                            }
                        } label: {
                            ItemRow(item: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        } detail: {
            Text("Select an item")
        }
        .searchable(text: $searchText)
        .sheet(isPresented: $showingAddItem) {
            NavigationStack {
                NewItemEditorView(parentContainer: nil)
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = rootItems[index]
            if item.itemType == .container {
                // Recursively delete children
                let childItems = item.children
                for child in childItems {
                    modelContext.delete(child)
                }
            }
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: InventoryItem.self, inMemory: true)
}

