//
//  TestContainer.swift
//  Accio6
//
//  Created by Scott McGregor on 12/24/24.
//


import SwiftData
@testable import Accio6

/// Shared test container for unit tests
struct TestContainer {
    static func createTestContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(for: InventoryItem.self, configurations: config)
    }
    
    static func createSampleData(in context: ModelContext) {
        let container = InventoryItem(itemName: "Test Container", itemType: .container)
        context.insert(container)
        
        let item1 = InventoryItem(itemName: "Test Item 1", parentID: container.id)
        let item2 = InventoryItem(itemName: "Test Item 2", parentID: container.id)
        context.insert(item1)
        context.insert(item2)
    }
}