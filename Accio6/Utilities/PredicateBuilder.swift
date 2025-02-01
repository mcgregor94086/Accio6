import Foundation
import SwiftData

struct PredicateBuilder {
    static func childrenPredicate(parentID: UUID?) -> Predicate<InventoryItem> {
        print("Building children predicate for parentID: \(String(describing: parentID))")
        if let targetParentID = parentID {
            return #Predicate<InventoryItem> { item in
                item.parentID == targetParentID
            }
        } else {
            return #Predicate<InventoryItem> { item in
                item.parentID == nil
            }
        }
    }
    
    static func parentPredicate(childID: UUID?) -> Predicate<InventoryItem> {
        if let targetChildID = childID {
            return #Predicate<InventoryItem> { item in
                item.id == targetChildID
            }
        } else {
            return #Predicate<InventoryItem> { _ in
                false
            }
        }
    }
    
    static func tagsPredicate(containing tag: String) -> Predicate<InventoryItem> {
        let searchTag = tag
        return #Predicate<InventoryItem> { item in
            item.tags.contains(searchTag)
        }
    }
    
    static func buildSearchPredicate(searchText: String) -> Predicate<InventoryItem> {
        if searchText.isEmpty {
            return #Predicate<InventoryItem> { _ in true }
        }
        let searchTerm = searchText
        return #Predicate<InventoryItem> { item in
            item.itemName.localizedStandardContains(searchTerm)
        }
    }
}
