import Foundation
import SwiftData

@Model
final class InventoryItem {
    var id: UUID?
    var itemName: String
    var itemType: ItemType
    var parentID: UUID?
    var tagsString: String
    
    var tags: [String] {
        get {
            tagsString.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        }
        set {
            tagsString = newValue.joined(separator: ", ")
        }
    }
    
    init(
        id: UUID? = UUID(),
        itemName: String,
        itemType: ItemType = .item,
        tags: [String] = [],
        parentID: UUID? = nil
    ) {
        self.id = id
        self.itemName = itemName
        self.itemType = itemType
        self.tagsString = tags.joined(separator: ", ")
        self.parentID = parentID
    }
}

enum ItemType: String, Codable, CaseIterable {
    case item
    case container
    
    var icon: String {
        switch self {
        case .container:
            return "folder"
        case .item:
            return "doc"
        }
    }
}
