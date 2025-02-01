import SwiftUI

extension ItemType {
    var iconColor: SwiftUI.Color {
        switch self {
        case .container:
            return .blue
        case .item:
            return .primary
        }
    }
}

extension InventoryItem {
    static var preview: InventoryItem {
        InventoryItem(
            itemName: "Preview Item",
            itemType: .item,
            tags: ["preview", "test"]
        )
    }
    
    static var previewContainer: InventoryItem {
        InventoryItem(
            itemName: "Preview Container",
            itemType: .container,
            tags: ["preview", "container"]
        )
    }
}
