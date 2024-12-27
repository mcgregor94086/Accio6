//
//  ChildManagerView.swift
//  Accio6
//
//  Created by [Your Name] on [Date].
//

import SwiftUI
import SwiftData

struct ChildManagerView: View {
    @Binding var item: InventoryItem
    let allItems: [InventoryItem]

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Manage Child Items")) {
                    ForEach(allItems.filter { $0.parentID == item.id }, id: \.id) { child in
                        HStack {
                            Text(child.itemName)
                                .foregroundColor(.blue)
                            Spacer()
                            Menu {
                                Button("Reparent to Root") {
                                    child.parentID = nil
                                    saveChanges()
                                }
                                Button("Delete", role: .destructive) {
                                    deleteChild(child)
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                    }
                    Button("Add New Child") {
                        createNewChild()
                    }
                }
            }
            .navigationTitle("Child Manager")
        }
    }

    // MARK: - Actions

    private func deleteChild(_ child: InventoryItem) {
        context.delete(child)
        saveChanges()
    }

    private func createNewChild() {
        let newChild = InventoryItem(
            itemName: "New Child",
            itemType: .item, // Correct order: itemType comes before parentID
            parentID: item.id
        )
        context.insert(newChild)
        saveChanges()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}
