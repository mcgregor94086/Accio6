//
//  ContainerView.swift
//  Accio6
//
//  Created by Scott McGregor on 12/22/24.
//

import SwiftData
import SwiftUI

/// Main view for displaying and managing container contents
struct ContainerView: View {
    @Environment(\.modelContext) private var modelContext
    let container: InventoryItem
    @Query private var children: [InventoryItem]
    @State private var showingAddSheet = false
    
    init(container: InventoryItem) {
        self.container = container
        let predicate = PredicateHelper.childrenPredicate(parentId: container.id)
        _children = Query(filter: predicate, sort: [SortDescriptor(\InventoryItem.itemName)])
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
                    ContentUnavailableView {
                        Label("Empty Container", systemImage: "square.dashed")
                    } description: {
                        Text("Add items using the + button")
                    }
                } else {
                    ForEach(children) { item in
                        NavigationLink {
                            if item.isContainer {
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
                    showingAddSheet = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                NewItemEditorView(parentContainer: container)
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = children[index]
            if item.isContainer {
                deleteChildren(of: item)
            }
            modelContext.delete(item)
        }
    }
    
    private func deleteChildren(of item: InventoryItem) {
        guard let childItems = try? modelContext.fetch(FetchDescriptor<InventoryItem>(
            predicate: PredicateHelper.childrenPredicate(parentId: item.id)
        )) else { return }
        
        childItems.forEach { child in
            if child.isContainer {
                deleteChildren(of: child)
            }
            modelContext.delete(child)
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


