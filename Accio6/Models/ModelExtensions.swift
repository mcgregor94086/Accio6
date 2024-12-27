import Foundation
import SwiftData

extension InventoryItem {
    // MARK: - Basic Properties
    var isContainer: Bool {
        itemType == .container
    }
    
    var isRoot: Bool {
        parentID == nil
    }
    
    // MARK: - Children Methods
    
    /// Fetches all children of this item
    ///
    /// SwiftData Predicate Rules:
    /// 1. When comparing UUIDs, both sides must be optional (UUID?)
    /// 2. The property being compared must be accessed via the predicate parameter
    /// 3. The comparison value must be explicitly typed
    /// 4. Descriptor must be var, not let, as predicate is set after creation
    var children: [InventoryItem] {
        guard let context = self.modelContext else { return [] }
        
        // Create descriptor with sort order
        var descriptor = FetchDescriptor<InventoryItem>(
            sortBy: [SortDescriptor(\.itemName)]
        )
        
        // Store ID as UUID? to match parentID type
        let parentId: UUID? = self.id
        
        // Create predicate with explicit typing and parameter access
        descriptor.predicate = #Predicate<InventoryItem> { item in
            // Compare optional to optional (UUID? to UUID?)
            item.parentID == parentId
        }
        
        return (try? context.fetch(descriptor)) ?? []
    }
    
    var hasChildren: Bool {
        !children.isEmpty
    }
    
    var childCount: Int {
        children.count
    }
    
    var childContainers: [InventoryItem] {
        children.filter { $0.isContainer }
    }
    
    // MARK: - Parent Methods
    
    /// Fetches the parent of this item
    ///
    /// SwiftData Predicate Rules:
    /// 1. When comparing UUIDs, use explicit typing
    /// 2. Access properties through the predicate parameter
    /// 3. Descriptor must be var for predicate assignment
    var parent: InventoryItem? {
        guard let context = self.modelContext,
              let parentID = self.parentID else { return nil }
        
        var descriptor = FetchDescriptor<InventoryItem>()
        
        // Create predicate comparing non-optional to non-optional UUID
        descriptor.predicate = #Predicate<InventoryItem> { item in
            // Both sides are UUID (not optional)
            item.id == parentID
        }
        
        return try? context.fetch(descriptor).first
    }
    
    var parentPath: [InventoryItem] {
        var path: [InventoryItem] = []
        var current = self.parent
        
        while let item = current {
            path.insert(item, at: 0)
            current = item.parent
        }
        
        return path
    }
    
    // MARK: - Mutation Methods
    func addChild(_ child: InventoryItem) {
        child.parentID = self.id
    }
    
    func removeChild(_ child: InventoryItem) {
        child.parentID = nil
    }
    
    func removeAllChildren() {
        for child in children {
            removeChild(child)
        }
    }
    
    func moveToContainer(_ newParent: InventoryItem?) {
        self.parentID = newParent?.id
    }
    
    // MARK: - Validation Methods
    var canAddChildren: Bool {
        isContainer && modelContext != nil
    }
    
    func canAddToContainer(_ container: InventoryItem?) -> Bool {
        guard let container = container else { return true }
        return container.id != self.id && !container.parentPath.contains(where: { $0.id == self.id })
    }
    
    // MARK: - Debug Helpers
    var debugDescription: String {
        """
        Item: \(itemName)
        ID: \(id.uuidString)
        Type: \(itemType.rawValue)
        Parent: \(parent?.itemName ?? "None")
        Children: \(childCount)
        """
    }
    
    var hierarchyDescription: String {
        var output = itemName
        if !children.isEmpty {
            output += " (\(children.count))"
            let childDescriptions = children
                .sorted(by: { $0.itemName < $1.itemName })
                .map { "  " + $0.hierarchyDescription.replacingOccurrences(of: "\n", with: "\n  ") }
            output += "\n" + childDescriptions.joined(separator: "\n")
        }
        return output
    }
}
