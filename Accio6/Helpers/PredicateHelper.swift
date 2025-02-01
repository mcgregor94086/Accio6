import SwiftData
import Foundation

/// Helper for creating common predicates used throughout the app
enum PredicateHelper {
    /// Creates a predicate for searching items
    static func searchPredicate(query: String) -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { item in
            item.itemName.localizedStandardContains(query)
        }
    }
    
    /// Creates a predicate for finding children of a container
    static func childrenPredicate(parentId: UUID) -> Predicate<InventoryItem> {
        #Predicate<InventoryItem> { item in
            item.parentId == parentId
        }
    }
} 