import SwiftUI
import SwiftData

struct ItemEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var item: InventoryItem
    
    @State private var itemName: String
    @State private var itemType: ItemType
    @State private var tags: [String]
    
    init(item: InventoryItem) {
        self.item = item
        _itemName = State(initialValue: item.itemName)
        _itemType = State(initialValue: item.itemType)
        _tags = State(initialValue: item.tags)
    }
    
    var body: some View {
        Form {
            Section("Item Details") {
                TextField("Name", text: $itemName)
                Picker("Type", selection: $itemType) {
                    ForEach(ItemType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
            }
            
            Section("Tags") {
                TagEditorView(tags: $tags)
            }
        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
                }
            }
        }
    }
    
    private func saveChanges() {
        item.itemName = itemName
        item.itemType = itemType
        item.tags = tags
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    let item = InventoryItem(
        itemName: "Test Item",
        itemType: .item,
        tags: ["test"]
    )
    container.mainContext.insert(item)
    
    return NavigationStack {
        ItemEditView(item: item)
    }
    .modelContainer(container)
}
