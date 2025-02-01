import XCTest
import SwiftData
@testable import Accio6

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
    
    func testInventoryItemCreation() throws {
        let inventoryItem = InventoryItem(itemName: "Test")
        modelContext.insert(inventoryItem)
        XCTAssertEqual(inventoryItem.itemName, "Test")
        XCTAssertEqual(inventoryItem.itemType, .item)
    }
    
    func testInventoryItemContainer() throws {
        let container = InventoryItem(itemName: "Container", itemType: .container)
        let child = InventoryItem(itemName: "Child")
        modelContext.insert(container)
        modelContext.insert(child)
        container.children.append(child)
        child.parentID = container.id
        XCTAssertEqual(container.children.count, 1)
    }
} 