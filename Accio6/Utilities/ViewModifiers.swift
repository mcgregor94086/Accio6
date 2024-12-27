import SwiftUI
import SwiftData

// Define the environment key properly
private struct ItemCountKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

// Define the environment value properly
extension EnvironmentValues {
    var itemCount: Int {
        get { self[ItemCountKey.self] }
        set { self[ItemCountKey.self] = newValue }
    }
}

struct ItemQueryModifier: ViewModifier {
    @Query private var inventoryItems: [InventoryItem]
    
    init(filter: Predicate<InventoryItem>? = nil) {
        // Fix: Use proper sort descriptor without closure
        _inventoryItems = Query(
            filter: filter,
            sort: [SortDescriptor(\InventoryItem.itemName)]
        )
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.itemCount, inventoryItems.count)
            // Fix: Proper animation syntax
            .animation(.default, value: inventoryItems.count)
    }
}

extension View {
    func withItemQuery(filter: Predicate<InventoryItem>? = nil) -> some View {
        modifier(ItemQueryModifier(filter: filter))
    }
}
