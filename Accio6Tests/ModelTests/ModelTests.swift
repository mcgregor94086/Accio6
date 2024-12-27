//
//  ModelTests.swift
//  Accio6
//
//  Created by Scott McGregor on 12/23/24.
//


import XCTest
import SwiftData
@testable import Accio6

/// Tests for the core data model functionality
final class ModelTests: XCTestCase {
    // Test container that's reset for each test
    var container: ModelContainer!
    var context: ModelContext!
    
    /// Set up a fresh test environment before each test
    override func setUp() {
        super.setUp()
        // Create an in-memory container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: InventoryItem.self, configurations: config)
        context = container.mainContext
    }
    
    /// Clean up after each test
    override func tearDown() {
        container = nil
        context = nil
        super.tearDown()
    }
    
    /// Test creating a basic item
    func testCreateItem() {
        // When we create a new item
        let item = InventoryItem(itemName: "Test Item")
        context.insert(item)
        
        // Then it should have the correct properties
        XCTAssertEqual(item.itemName, "Test Item")
        XCTAssertEqual(item.itemType, .item)
        XCTAssertNil(item.parentID)
        XCTAssertTrue(item.tags.isEmpty)
    }
    
    /// Test parent-child relationships
    func testContainerRelationships() {
        // Given a container
        let container = InventoryItem(itemName: "Container", itemType: .container)
        context.insert(container)
        
        // When we add items to it
        let item1 = InventoryItem(itemName: "Item 1", parentID: container.id)
        let item2 = InventoryItem(itemName: "Item 2", parentID: container.id)
        context.insert(item1)
        context.insert(item2)
        
        // Then the relationships should be correct
        XCTAssertEqual(container.children.count, 2)
        XCTAssertEqual(item1.parent?.id, container.id)
        XCTAssertEqual(item2.parent?.id, container.id)
    }
}