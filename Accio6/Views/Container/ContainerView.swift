//
//  ContainerView.swift
//  Accio6
//
//  Created by Scott McGregor on 12/22/24.
//


import SwiftUI
import SwiftData

struct ContainerView: View {
    @Environment(\.modelContext) private var modelContext
    let container: InventoryItem
    @Query private var children: [InventoryItem]
    
    init(container: InventoryItem) {
        self.container = container
        let predicate = PredicateHelper.basicParentPredicate(parentId: container.id)
        let sortDescriptor = SortDescriptor<InventoryItem>(\.itemName)
        _children = Query(filter: predicate, sort: [sortDescriptor])
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    ItemEditView(item: container)
                } label: {
                    HStack {
                        Image(systemName: "folder")
                            .foregroundStyle(.blue)
                        Text(container.itemName)
                    }
                }
            }
            
            Section {
                if children.isEmpty {
                    ContentUnavailableView(
                        "Empty Container",
                        systemImage: "square.dashed",
                        description: Text("Add items using the + button")
                    )
                } else {
                    ForEach(children) { item in
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
        }
        .navigationTitle("Container")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addItem()
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            NavigationStack {
                ItemEditView(item: item)
            }
        }
    }
    
    @State private var selectedItem: InventoryItem?
    
    private func addItem() {
        let sheet = NewItemEditorView(parentContainer: container)
        let host = UIHostingController(rootView: NavigationStack { sheet })
        host.isModalInPresentation = true
        host.modalPresentationStyle = .formSheet
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(host, animated: true)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = children[index]
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    let context = container.mainContext
    let testContainer = InventoryItem(itemName: "Test Container", itemType: .container)
    context.insert(testContainer)
    
    let item1 = InventoryItem(itemName: "Item 1", parentID: testContainer.id)
    let item2 = InventoryItem(itemName: "Item 2", parentID: testContainer.id)
    context.insert(item1)
    context.insert(item2)
    
    return NavigationStack {
        ContainerView(container: testContainer)
    }
    .modelContainer(container)
}