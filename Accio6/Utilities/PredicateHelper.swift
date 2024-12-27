import Foundation
import SwiftData

/// Helper for creating SwiftData predicates with proper optional handling
enum PredicateHelper {
    /// Creates a predicate for finding children of a parent
    /// - Parameter parentId: Optional UUID of the parent
    static func childrenPredicate(parentId: UUID?) -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { inventoryItem in
            inventoryItem.parentID == parentId
        }
    }

    /// Creates a predicate for finding items by exact ID
    /// - Parameter id: Non-optional UUID to match
    static func idPredicate(id: UUID) -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { inventoryItem in
            inventoryItem.id == id
        }
    }

    /// Creates a predicate for finding root items (no parent)
    static func rootItemsPredicate() -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { inventoryItem in
            inventoryItem.parentID == nil
        }
    }

    /// Creates a predicate for finding items by name
    /// - Parameter searchText: Text to search for
    static func nameSearchPredicate(searchText: String) -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { inventoryItem in
            inventoryItem.itemName.localizedStandardContains(searchText)
        }
    }

    /// Creates a predicate for finding items by type
    /// - Parameter type: Item type to match
    static func typePredicate(type: InventoryItemType) -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { inventoryItem in
            inventoryItem.itemType == type
        }
    }

    /// Creates a predicate for finding empty containers
    static func emptyContainersPredicate() -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { inventoryItem in
            inventoryItem.itemType == .container && inventoryItem.children.isEmpty
        }
    }
}
