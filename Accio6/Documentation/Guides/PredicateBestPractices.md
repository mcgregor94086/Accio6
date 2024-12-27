
# SwiftData Predicate Best Practices

## Key Rules
1. Always use explicit parameter access in predicates
2. Match types exactly (especially for UUID comparisons)
3. Keep predicates simple and atomic
4. Use var for descriptors that will have predicates assigned
5. Handle optionals consistently

## Common Patterns

### Correct UUID Comparison
swift
// Good
#Predicate<InventoryItem> { item in
item.parentID == someUUID
}
// Bad - Don't use implicit property access
#Predicate<InventoryItem> {
$0.parentID == self.id // Will fail
}

### Optional Handling
swift
// Good
#Predicate<InventoryItem> { item in
item.parentID == nil
}
// Bad - Don't mix optional types
#Predicate<InventoryItem> { item in
item.id == someOptionalUUID // Type mismatch
}
```

Now, let's update our files with comprehensive comments:

swift:Utilities/PredicateHelper.swift
import Foundation
import SwiftData
/// Helper for creating SwiftData predicates
///
/// Best Practices for SwiftData Predicates:
/// 1. Always use explicit parameter access (e.g., item.property not $0.property)
/// 2. Match types exactly (especially for UUID comparisons)
/// 3. Keep predicates simple and atomic
/// 4. Use var for descriptors that will have predicates assigned
/// 5. Handle optionals consistently
enum PredicateHelper {
// MARK: - Basic Predicates
/// Creates a predicate for finding children of a parent
/// - Parameter parentId: Optional UUID of the parent
/// - Note: Uses explicit parameter access for SwiftData compatibility
static func childrenPredicate(parentId: UUID?) -> Predicate<InventoryItem> {
#Predicate<InventoryItem> { item in
// Correct: Explicit member access through parameter
item.parentID == parentId
}
}
/// Creates a predicate for finding an item by ID
/// - Parameter id: UUID to match
/// - Note: Ensures type matching between compared UUIDs
static func itemPredicate(id: UUID) -> Predicate<InventoryItem> {
#Predicate<InventoryItem> { item in
// Correct: Non-optional UUID comparison
item.id == id
}
}
// ... rest of the predicates with similar documentation ...
}
swift:Views/ContentView.swift
import SwiftUI
import SwiftData
/// Main content view for the application
///
/// SwiftData Predicate Usage:
/// - Use PredicateHelper for consistent predicate creation
/// - Ensure proper type matching in @Query filters
/// - Keep predicate expressions simple
struct ContentView: View {
@Environment(\.modelContext) private var modelContext
// Correct: Using PredicateHelper for predicate creation
@Query(filter: PredicateHelper.rootItemsPredicate(),
sort: \InventoryItem.itemName) private var rootItems: [InventoryItem]
// ... rest of the view ...
}
swift:Models/ModelExtensions.swift
import Foundation
import SwiftData
/// Extensions for InventoryItem model
///
/// Predicate Usage Guidelines:
/// 1. Use var for descriptors that will have predicates assigned
/// 2. Access properties through predicate parameters
/// 3. Match optional types carefully
/// 4. Keep predicate expressions simple
extension InventoryItem {
// ... existing code with added comments ...
}
