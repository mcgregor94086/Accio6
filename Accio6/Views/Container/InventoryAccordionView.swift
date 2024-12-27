//
//  InventoryAccordionView.swift
//  Accio6
//
//  Created by [Your Name] on [Date].
//

import SwiftUI

struct InventoryAccordionView: View {
    @Binding var expandedItems: Set<UUID> // Tracks expanded items
    let item: InventoryItem
    let allItems: [InventoryItem]

    var childItems: [InventoryItem] {
        allItems.filter { $0.parentID == item.id }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if item.itemType == .container && !childItems.isEmpty {
                    Button(action: toggleExpansion) {
                        Image(systemName: expandedItems.contains(item.id) ? "chevron.down" : "chevron.right")
                            .frame(width: 20) // Keeps alignment consistent
                    }
                } else {
                    Spacer().frame(width: 20) // Empty space for non-containers
                }
                Image(systemName: item.itemType == .container ? "folder" : "doc.text")
                Text(item.itemName)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 4)

            // Show children if expanded
            if expandedItems.contains(item.id) {
                ForEach(childItems) { child in
                    InventoryAccordionView(
                        expandedItems: $expandedItems,
                        item: child,
                        allItems: allItems
                    )
                    .padding(.leading, 20) // Indentation for children
                }
            }
        }
    }

    private func toggleExpansion() {
        if expandedItems.contains(item.id) {
            expandedItems.remove(item.id)
        } else {
            expandedItems.insert(item.id)
        }
    }
}
