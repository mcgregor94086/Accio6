# SwiftData Predicate Best Practices

## Core Rules
1. Always use explicit parameter access in predicates
2. Match types exactly in comparisons
3. Keep predicates simple and atomic
4. Use var for descriptors that need predicate assignment
5. Handle optionals consistently

## Common Patterns

### Correct Parameter Access
swift
// Good ✅
#Predicate<InventoryItem> { inventoryItem in
    inventoryItem.parentID == someUUID
}
// Bad ❌
#Predicate<InventoryItem> {
$0.parentID == self.id
}

### Type Matching
swift
// Good ✅
#Predicate<InventoryItem> { item in
item.id == searchId // Both non-optional UUID
}
// Bad ❌
#Predicate<InventoryItem> { item in
item.id == optionalId // Type mismatch
}


### Optional Handling


## Best Practices
1. Use PredicateHelper for common queries
2. Document predicate assumptions
3. Test edge cases
4. Handle errors gracefully
5. Keep predicates maintainable

## Common Issues and Solutions
- UUID comparison issues
- Optional handling
- Complex predicate composition
- Performance considerations
