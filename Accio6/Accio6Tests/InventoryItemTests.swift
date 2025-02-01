import XCTest
import SwiftData
@testable import Accio6

@MainActor
final class InventoryItemTests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: InventoryItem.self, configurations: config)
        modelContext = modelContainer.mainContext
    }
    
    override func tearDownWithError() throws {
        modelContainer = nil
        modelContext = nil
    }
    
    func testItemInitialization() throws {
        let item = InventoryItem(
            itemName: "Test Item",
            parentID: nil,
            itemType: .item
        )
        modelContext.insert(item)
        
        // Test fetch with single-expression predicate
        let descriptor = FetchDescriptor<InventoryItem>(
            predicate: #Predicate<InventoryItem> { item in
                item.id == item.id  // Single expression
            }
        )
        
        let items = try modelContext.fetch(descriptor)
        XCTAssertEqual(items.first?.itemName, "Test Item")
    }
    
    func testParentChildRelationship() throws {
        let parent = InventoryItem(
            itemName: "Parent",
            parentID: nil,
            itemType: .container
        )
        modelContext.insert(parent)
        
        let child = InventoryItem(
            itemName: "Child",
            parentID: parent.id,
            itemType: .item
        )
        modelContext.insert(child)
        
        // Test fetch with single-expression predicate
        let descriptor = FetchDescriptor<InventoryItem>(
            predicate: #Predicate<InventoryItem> { item in
                item.parentID == parent.id  // Single expression
            }
        )
        
        let children = try modelContext.fetch(descriptor)
        XCTAssertEqual(children.count, 1)
    }
} 