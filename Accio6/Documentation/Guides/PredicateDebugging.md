# SwiftData Predicate Debugging Guide

## Common Issues and Solutions

### 1. Member Access Without Explicit Base

#### Symptoms:

swift
// Error: Member access without explicit base
#Predicate<InventoryItem> { parentID == nil }

#### Solution:
swift
// Fixed: Use explicit item parameter
#Predicate<InventoryItem> { item in
item.parentID == nil
}

### 2. Optional Type Mismatches

#### Symptoms:
swift
// Error: Cannot convert UUID to UUID?
#Predicate<InventoryItem> { item in
item.id == optionalUUID
}

#### Solution:
swift
// Fixed: Match optional types
#Predicate<InventoryItem> { item in
item.parentID == optionalUUID // Both UUID?
}

### 3. Debugging Steps

1. Check Predicate Structure:
   - Verify explicit parameter usage
   - Confirm property access through parameter
   - Validate optional types match

2. Use Validation Helpers:
swift
do {
try PredicateValidator.validatePredicate(myPredicate)
} catch {
print("Validation failed: error)") } ```

 3. Test with Sample Data: 
 ```swift func debugPredicate(_ predicate: Predicate<InventoryItem>) 
 { let descriptor = FetchDescriptor(predicate: predicate)
  do 
     { let results = try context.fetch(descriptor) 
        print("Found \(results.count) matches") 
    } catch { print("Fetch failed: \(error)") } 
} ``` 
 ### 
 
 4. Common Patterns 
 #### Optional UUID Comparison: 
 ```swift // Correct pattern static func byParent(id: UUID?) -> Predicate<InventoryItem> { #Predicate<InventoryItem> { item in item.parentID == id // Both UUID? } } ``` #### Non-Optional UUID Comparison: ```swift // Correct pattern static func byId(id: UUID) -> Predicate<InventoryItem> { #Predicate<InventoryItem> { item in item.id == id // Both UUID } } ``` ## Troubleshooting Checklist - [ ] Using explicit parameter (e.g., `item`) - [ ] Accessing properties through parameter - [ ] Matching optional types - [ ] Using proper comparison operators - [ ] Handling nil cases correctly ```