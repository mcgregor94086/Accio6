import SwiftUI
import SwiftData

struct InventoryItemDetail: View {
    let item: InventoryItem
    
    var body: some View {
        List {
            Section("Details") {
                LabeledContent("Name", value: item.itemName)
                LabeledContent("Type", value: item.itemType.rawValue)
                if let parentID = item.parentID {
                    LabeledContent("Parent ID", value: parentID.uuidString)
                }
            }
            
            Section("Tags") {
                if item.tags.isEmpty {
                    Text("No Tags")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
            }
        }
        .navigationTitle(item.itemName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let item = InventoryItem(
        itemName: "Test Item",
        itemType: .item,
        tags: ["test", "preview"]
    )
    
    NavigationStack {
        InventoryItemDetail(item: item)
    }
}
