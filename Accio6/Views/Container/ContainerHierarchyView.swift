import SwiftUI
import SwiftData

struct ContainerHierarchyView: View {
    @Query private var allItems: [InventoryItem]
    let selectedItem: InventoryItem?
    let onSelect: (InventoryItem) -> Void
    
    var rootItems: [InventoryItem] {
        allItems.filter { $0.parentID == nil }
    }
    
    init(selectedItem: InventoryItem?, onSelect: @escaping (InventoryItem) -> Void) {
        self.selectedItem = selectedItem
        self.onSelect = onSelect
        
        // Initialize the Query with a sort descriptor
        let sortDescriptor = SortDescriptor<InventoryItem>(\.itemName)
        _allItems = Query(sort: [sortDescriptor])
    }
    
    var body: some View {
        List {
            ForEach(rootItems) { item in
                HierarchyItemView(
                    item: item,
                    allItems: allItems,
                    selectedItem: selectedItem,
                    onSelect: onSelect
                )
            }
        }
        .listStyle(.inset)
    }
}

struct HierarchyItemView: View {
    let item: InventoryItem
    let allItems: [InventoryItem]
    let selectedItem: InventoryItem?
    let onSelect: (InventoryItem) -> Void
    @State private var isExpanded = true
    
    var childItems: [InventoryItem] {
        allItems.filter { $0.parentID == item.id }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                if !childItems.isEmpty && item.itemType == .container {
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.clear)
                }
                
                Image(systemName: item.itemType == .container ? "folder" : "doc")
                    .foregroundStyle(item.itemType == .container ? .blue : .gray)
                
                Text(item.itemName)
                
                if item.id == selectedItem?.id {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if item.itemType == .container {
                    onSelect(item)
                }
            }
            .padding(.vertical, 4)
            
            if isExpanded && !childItems.isEmpty {
                ForEach(childItems) { child in
                    HierarchyItemView(
                        item: child,
                        allItems: allItems,
                        selectedItem: selectedItem,
                        onSelect: onSelect
                    )
                    .padding(.leading)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContainerHierarchyView(
            selectedItem: nil,
            onSelect: { _ in }
        )
        .modelContainer(for: InventoryItem.self, inMemory: true)
    }
}
