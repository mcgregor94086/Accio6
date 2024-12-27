//
//  ChildrenView.swift
//  Accio6
//
//  Created by Scott McGregor on 12/6/24.
//

import SwiftUI
import SwiftData

struct ChildrenView: View {
    @Environment(\.modelContext) var context
    var parentID: UUID
    @State private var children: [InventoryItem] = []

    var body: some View {
        List(children, id: \.id) { item in
            Text(item.itemName)
        }
        .onAppear(perform: fetchChildren)
        .navigationTitle("Children")
    }

    private func fetchChildren() {
        do {
            let fetchDescriptor = FetchDescriptor<InventoryItem>(
                predicate: #Predicate { $0.parentID == parentID }
            )
            children = try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching children: \(error)")
        }
    }
}
