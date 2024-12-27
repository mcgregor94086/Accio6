# SwiftData Guidelines

## Model Design

### Basic Rules
1. Keep models simple
2. Use clear property names
3. Document relationships
4. Handle optionals carefully

### Model Example

swift
@Model
final class InventoryItem {
var id: UUID
var itemName: String
var itemType: InventoryItemType
var parentID: UUID?
var tags: [String]
init(itemName: String, ...) {
self.id = UUID()
self.itemName = itemName
// ...
}
}


## Data Operations

### Fetching
- Use appropriate predicates
- Sort results consistently
- Handle errors gracefully
- Cache when appropriate

### Saving
- Save in background when possible
- Handle conflicts
- Validate before saving
- Maintain data integrity

## Best Practices

### Performance
1. Batch operations
2. Use indexes appropriately
3. Monitor memory usage
4. Profile performance

### Error Handling
1. Validate input
2. Handle edge cases
3. Provide user feedback
4. Log errors appropriately

### Testing
1. Use in-memory storage
2. Test CRUD operations
3. Verify relationships
4. Check error conditions