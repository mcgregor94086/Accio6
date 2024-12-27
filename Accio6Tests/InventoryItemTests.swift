import XCTest
@testable import Accio6

final class InventoryItemTests: XCTestCase {
    func testInventoryItemCreation() {
        let inventoryItem = InventoryItem(itemName: "Test")
        XCTAssertEqual(inventoryItem.itemName, "Test")
        XCTAssertEqual(inventoryItem.itemType, .item)
    }
    
    func testInventoryItemContainer() {
        let container = InventoryItem(itemName: "Container", itemType: .container)
        let child = InventoryItem(itemName: "Child")
        container.children.append(child)
        XCTAssertEqual(container.children.count, 1)
    }
} 