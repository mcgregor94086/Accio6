import SwiftUI
import SwiftData

struct ItemDetailView: View {
    let item: InventoryItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section("Details") {
                LabeledContent("Name", value: item.itemName)
                LabeledContent("Type", value: item.itemType.rawValue.capitalized)
            }
            
            if !item.tags.isEmpty {
                Section("Tags") {
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
    NavigationStack {
        ItemDetailView(item: InventoryItem(
            itemName: "Test Item",
            itemType: .item,
            tags: ["test", "preview"]
        ))
    }
}
