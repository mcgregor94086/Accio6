//
//  ParentEditorView.swift
//  Accio6
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

struct ParentEditorView: View {
    @Binding var item: InventoryItem
    let allItems: [InventoryItem]

    @Environment(\.dismiss) private var dismiss

    var availableParents: [InventoryItem] {
        allItems.filter { $0.id != item.id && !createsCycle(for: $0) }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Select New Parent")) {
                    ForEach(availableParents, id: \.id) { parent in
                        Button(parent.itemName) {
                            item.parentID = parent.id
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Edit Parent")
        }
    }

    private func createsCycle(for parent: InventoryItem) -> Bool {
        var visited = Set<UUID>()
        var stack: [UUID] = [parent.id]

        while let current = stack.popLast() {
            if visited.contains(current) {
                return true
            }
            visited.insert(current)
            let children = allItems.filter { $0.parentID == current }
            stack.append(contentsOf: children.map { $0.id })
        }
        return false
    }
}
