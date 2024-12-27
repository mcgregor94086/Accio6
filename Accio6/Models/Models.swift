import Foundation
import SwiftData

@Model
final class InventoryItem {
    var id: UUID
    var itemName: String
    var itemType: InventoryItemType
    var parentID: UUID?
    var tags: [String]
    
    init(itemName: String, itemType: InventoryItemType = .item, parentID: UUID? = nil) {
        self.id = UUID()
        self.itemName = itemName
        self.itemType = itemType
        self.parentID = parentID
        self.tags = []
    }
}

enum InventoryItemType: String, Codable {
    case item
    case container
}
