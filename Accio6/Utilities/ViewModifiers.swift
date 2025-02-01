import SwiftData
import SwiftUI

// Environment key definition stays the same
private struct ItemCountKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

// Environment value extension stays the same
extension EnvironmentValues {
    var itemCount: Int {
        get { self[ItemCountKey.self] }
        set { self[ItemCountKey.self] = newValue }
    }
}

struct ItemQueryModifier: ViewModifier {
    @Query private var inventoryItems: [InventoryItem]

    init(filter: Predicate<InventoryItem>? = nil) {
        let defaultPredicate = #Predicate<InventoryItem> { item in
            true
        }

        _inventoryItems = Query(
            filter: filter ?? defaultPredicate,
            sort: [SortDescriptor(\.itemName)]
        )
    }

    func body(content: Content) -> some View {
        content
            .environment(\.itemCount, inventoryItems.count)  // Fixed: Using keyPath syntax
            .animation(.default, value: inventoryItems.count)
    }
}

extension View {
    func withItemQuery(filter: Predicate<InventoryItem>? = nil) -> some View {
        modifier(ItemQueryModifier(filter: filter))
    }
}
