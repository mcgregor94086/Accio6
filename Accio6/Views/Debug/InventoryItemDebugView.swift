import SwiftUI
import SwiftData

struct InventoryItemDebugView: View {
    let item: InventoryItem
    
    var body: some View {
        List {
            Section("Basic Info") {
                LabeledContent("ID", value: item.id?.uuidString ?? "No ID")
                LabeledContent("Name", value: item.itemName)
                LabeledContent("Type", value: item.itemType.rawValue)
                LabeledContent("Parent ID", value: item.parentID?.uuidString ?? "No Parent")
            }
            
            if !item.tags.isEmpty {
                Section("Tags") {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
            }
        }
        .navigationTitle("Debug Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        InventoryItemDebugView(item: InventoryItem(
            itemName: "Test Item",
            itemType: .item,
            tags: ["test", "debug"]
        ))
    }
}
