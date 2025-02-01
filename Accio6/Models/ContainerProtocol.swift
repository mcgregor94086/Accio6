import SwiftUI
import SwiftData

// Protocol for container management
protocol ContainerManagement {
    func fetchChildren(for container: InventoryItem) async throws -> [InventoryItem]
    func deleteItem(_ item: InventoryItem) async throws
    func deleteChildren(of item: InventoryItem) async throws
}

// Protocol for container presentation
protocol ContainerPresentation {
    var displayIcon: String { get }
    var displayName: String { get }
    var childrenCount: Int { get }
}

// Protocol for container validation
protocol ContainerValidation {
    func canDeleteItem(_ item: InventoryItem) -> Bool
    func canAddItem(to container: InventoryItem) -> Bool
}
