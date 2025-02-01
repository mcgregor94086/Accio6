// Purpose: Define the core item type abstraction used across the app
import Foundation

/// Protocol defining the basic properties any item type must have
protocol ItemTypeProtocol {
    var displayName: String { get }
    var icon: String { get }
    var isContainer: Bool { get }
}

/// Concrete implementation of item types in the inventory system
enum ItemType: ItemTypeProtocol {
    case container
    case item
    
    var displayName: String {
        switch self {
        case .container: return "Container"
        case .item: return "Item"
        }
    }
    
    var icon: String {
        switch self {
        case .container: return "folder"
        case .item: return "doc"
        }
    }
    
    var isContainer: Bool {
        self == .container
    }
} 