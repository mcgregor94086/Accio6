//
//  final.swift
//  Accio6
//
//  Created by Scott McGregor on 12/23/24.
//


import XCTest
import SwiftData
@testable import Accio6

/// Tests for the PredicateHelper utility class
final class PredicateHelperTests: XCTestCase {
    // Test environment
    var container: ModelContainer!
    var context: ModelContext!
    
    // Test data references
    var rootContainer: InventoryItem!
    var subContainer: InventoryItem!
    var item1: InventoryItem!
    var item2: InventoryItem!
    var taggedItem: InventoryItem!
    var emptyContainer: InventoryItem!
    
    /// Set up fresh test environment before each test
    override func setUp() {
        super.setUp()
        container = TestContainer.createTestContainer()
        context = container.mainContext
        setupTestData()
    }
    
    /// Clean up after each test
    override func tearDown() {
        container = nil
        context = nil
        super.tearDown()
    }
    
    /// Creates a comprehensive set of test data
    private func setupTestData() {
        // Create root container
        rootContainer = InventoryItem(itemName: "Root Container", itemType: .container)
        context.insert(rootContainer)
        
        // Create sub-container
        subContainer = InventoryItem(
            itemName: "Sub Container",
            itemType: .container,
            parentID: rootContainer.id
        )
        context.insert(subContainer)
        
        // Create regular items
        item1 = InventoryItem(
            itemName: "Test Item One",
            parentID: subContainer.id
        )
        item2 = InventoryItem(
            itemName: "Test Item Two",
            parentID: subContainer.id
        )
        context.insert(item1)
        context.insert(item2)
        
        // Create tagged item
        taggedItem = InventoryItem(itemName: "Tagged Test Item")
        taggedItem.tags = ["test", "important", "sample"]
        context.insert(taggedItem)
        
        // Create empty container
        emptyContainer = InventoryItem(itemName: "Empty Container", itemType: .container)
        context.insert(emptyContainer)
    }
    
    // MARK: - Basic Predicate Tests
    
    func testByParentPredicate() {
        // Test root items (nil parent)
        let rootPredicate = PredicateHelper.byParent(id: nil)
        let rootDescriptor = FetchDescriptor<InventoryItem>(predicate: rootPredicate)
        let rootItems = try? context.fetch(rootDescriptor)
        
        XCTAssertNotNil(rootItems)
        XCTAssertEqual(rootItems?.count, 3) // rootContainer, taggedItem, emptyContainer
        XCTAssertTrue(rootItems?.contains(rootContainer) ?? false)
        XCTAssertTrue(rootItems?.contains(taggedItem) ?? false)
        XCTAssertTrue(rootItems?.contains(emptyContainer) ?? false)
        
        // Test items with specific parent
        let parentPredicate = PredicateHelper.byParent(id: subContainer.id)
        let parentDescriptor = FetchDescriptor<InventoryItem>(predicate: parentPredicate)
        let children = try? context.fetch(parentDescriptor)
        
        XCTAssertNotNil(children)
        XCTAssertEqual(children?.count, 2) // item1, item2
        XCTAssertTrue(children?.contains(item1) ?? false)
        XCTAssertTrue(children?.contains(item2) ?? false)
    }
    
    func testByIdPredicate() {
        // Test finding specific item by ID
        let predicate = PredicateHelper.byId(id: item1.id)
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        let result = try? context.fetch(descriptor)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.id, item1.id)
    }
    
    func testByTypePredicate() {
        // Test finding containers
        let containerPredicate = PredicateHelper.byType(type: .container)
        let containerDescriptor = FetchDescriptor<InventoryItem>(predicate: containerPredicate)
        let containers = try? context.fetch(containerDescriptor)
        
        XCTAssertNotNil(containers)
        XCTAssertEqual(containers?.count, 3) // rootContainer, subContainer, emptyContainer
        
        // Test finding regular items
        let itemPredicate = PredicateHelper.byType(type: .item)
        let itemDescriptor = FetchDescriptor<InventoryItem>(predicate: itemPredicate)
        let items = try? context.fetch(itemDescriptor)
        
        XCTAssertNotNil(items)
        XCTAssertEqual(items?.count, 3) // item1, item2, taggedItem
    }
    
    // MARK: - Search Predicate Tests
    
    func testByNamePredicate() {
        // Test case-insensitive name search
        let predicate = PredicateHelper.byName(contains: "test")
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        let results = try? context.fetch(descriptor)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 3) // item1, item2, taggedItem
    }
    
    func testRootItemsPredicate() {
        let predicate = PredicateHelper.rootItems()
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        let results = try? context.fetch(descriptor)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 3) // rootContainer, taggedItem, emptyContainer
        XCTAssertTrue(results?.contains(rootContainer) ?? false)
    }
    
    func testEmptyContainersPredicate() {
        let predicate = PredicateHelper.emptyContainers()
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        let results = try? context.fetch(descriptor)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 1) // emptyContainer
        XCTAssertTrue(results?.contains(emptyContainer) ?? false)
    }
    
    // MARK: - Complex Query Tests
    
    func testCombinedPredicates() {
        // Test combining root and container predicates
        let rootPredicate = PredicateHelper.rootItems()
        let containerPredicate = PredicateHelper.byType(type: .container)
        
        let combined = #Predicate<InventoryItem> { item in
            rootPredicate.evaluate(item) && containerPredicate.evaluate(item)
        }
        
        let descriptor = FetchDescriptor<InventoryItem>(predicate: combined)
        let results = try? context.fetch(descriptor)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 2) // rootContainer, emptyContainer
    }
    
    // MARK: - Performance Tests
    
    func testPredicatePerformance() {
        // Add many items for performance testing
        for i in 0..<1000 {
            let item = InventoryItem(itemName: "Performance Test \(i)")
            context.insert(item)
        }
        
        measure {
            let predicate = PredicateHelper.byName(contains: "Performance")
            let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
            _ = try? context.fetch(descriptor)
        }
    }
    
    // MARK: - Edge Cases
    
    func testEmptyNameSearch() {
        let predicate = PredicateHelper.byName(contains: "")
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        let results = try? context.fetch(descriptor)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 0)
    }
    
    func testNonExistentId() {
        let predicate = PredicateHelper.byId(id: UUID())
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        let results = try? context.fetch(descriptor)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 0)
    }
}