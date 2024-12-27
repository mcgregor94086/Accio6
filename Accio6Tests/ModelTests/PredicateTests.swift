//
//  PredicateTests.swift
//  Accio6
//
//  Created by Scott McGregor on 12/23/24.
//


import XCTest
import SwiftData
@testable import Accio6

/// Tests for all predicates used in the app
final class PredicateTests: XCTestCase {
    // Test environment
    var container: ModelContainer!
    var context: ModelContext!
    
    // Test data
    var parentContainer: InventoryItem!
    var childContainer: InventoryItem!
    var item1: InventoryItem!
    var item2: InventoryItem!
    var taggedItem: InventoryItem!
    
    /// Set up fresh test environment before each test
    override func setUp() {
        super.setUp()
        // Create in-memory container
        container = TestContainer.createTestContainer()
        context = container.mainContext
        
        // Create test hierarchy
        setupTestData()
    }
    
    /// Clean up after each test
    override func tearDown() {
        container = nil
        context = nil
        super.tearDown()
    }
    
    /// Creates a standard set of test items
    private func setupTestData() {
        // Create parent container
        parentContainer = InventoryItem(itemName: "Parent Container", itemType: .container)
        context.insert(parentContainer)
        
        // Create child container inside parent
        childContainer = InventoryItem(
            itemName: "Child Container",
            itemType: .container,
            parentID: parentContainer.id
        )
        context.insert(childContainer)
        
        // Create items in child container
        item1 = InventoryItem(
            itemName: "Test Item 1",
            parentID: childContainer.id
        )
        item2 = InventoryItem(
            itemName: "Test Item 2",
            parentID: childContainer.id
        )
        context.insert(item1)
        context.insert(item2)
        
        // Create tagged item
        taggedItem = InventoryItem(itemName: "Tagged Item")
        taggedItem.tags = ["test", "important", "sample"]
        context.insert(taggedItem)
    }
    
    // MARK: - Basic Predicate Tests
    
    /// Test finding items by parent ID
    func testChildrenPredicate() {
        // Given a parent container
        let predicate = PredicateHelper.byParent(id: childContainer.id)
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        
        // When we fetch its children
        let children = try? context.fetch(descriptor)
        
        // Then we should find the correct items
        XCTAssertNotNil(children)
        XCTAssertEqual(children?.count, 2)
        XCTAssertTrue(children?.contains(item1) ?? false)
        XCTAssertTrue(children?.contains(item2) ?? false)
    }
    
    /// Test finding items by ID
    func testItemPredicate() {
        // Given an item's ID
        let predicate = PredicateHelper.byId(id: item1.id)
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        
        // When we fetch by that ID
        let result = try? context.fetch(descriptor)
        
        // Then we should find exactly that item
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.id, item1.id)
    }
    
    /// Test finding containers only
    func testContainersPredicate() {
        // Given our test data
        let predicate = PredicateHelper.byType(type: .container)
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        
        // When we fetch containers
        let containers = try? context.fetch(descriptor)
        
        // Then we should find both containers
        XCTAssertNotNil(containers)
        XCTAssertEqual(containers?.count, 2)
        XCTAssertTrue(containers?.contains(parentContainer) ?? false)
        XCTAssertTrue(containers?.contains(childContainer) ?? false)
    }
    
    // MARK: - Search Predicate Tests
    
    /// Test name search
    func testNameSearchPredicate() {
        // Given a search term
        let predicate = PredicateHelper.byName(contains: "Test")
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        
        // When we search
        let results = try? context.fetch(descriptor)
        
        // Then we should find items with matching names
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 2) // item1 and taggedItem
        XCTAssertTrue(results?.contains(item1) ?? false)
    }
    
    /// Test finding root items
    func testRootItemsPredicate() {
        // Given our test data
        let predicate = PredicateHelper.rootItems()
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        
        // When we fetch root items
        let roots = try? context.fetch(descriptor)
        
        // Then we should find only top-level items
        XCTAssertNotNil(roots)
        XCTAssertEqual(roots?.count, 2) // parentContainer and taggedItem
        XCTAssertTrue(roots?.contains(parentContainer) ?? false)
        XCTAssertTrue(roots?.contains(taggedItem) ?? false)
    }
    
    /// Test finding empty containers
    func testEmptyContainersPredicate() {
        // Create an empty container
        let emptyContainer = InventoryItem(itemName: "Empty", itemType: .container)
        context.insert(emptyContainer)
        
        // Given our test data
        let predicate = PredicateHelper.emptyContainers()
        let descriptor = FetchDescriptor<InventoryItem>(predicate: predicate)
        
        // When we fetch empty containers
        let empties = try? context.fetch(descriptor)
        
        // Then we should find only the empty container
        XCTAssertNotNil(empties)
        XCTAssertEqual(empties?.count, 1)
        XCTAssertTrue(empties?.contains(emptyContainer) ?? false)
    }
    
    // MARK: - Complex Query Tests
    
    /// Test combining multiple predicates
    func testCombinedPredicates() {
        // Create a predicate for root containers
        let rootPredicate = PredicateHelper.rootItems()
        let containerPredicate = PredicateHelper.byType(type: .container)
        
        // Combine predicates
        let combined = #Predicate<InventoryItem> { item in
            rootPredicate.evaluate(item) && containerPredicate.evaluate(item)
        }
        
        let descriptor = FetchDescriptor<InventoryItem>(predicate: combined)
        
        // When we fetch
        let results = try? context.fetch(descriptor)
        
        // Then we should find only root containers
        XCTAssertNotNil(results)
        XCTAssertEqual(results?.count, 1)
        XCTAssertTrue(results?.contains(parentContainer) ?? false)
    }
}