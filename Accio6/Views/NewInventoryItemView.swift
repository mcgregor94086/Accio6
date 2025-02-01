import SwiftUI
import SwiftData

struct NewInventoryItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var itemName = ""
    @State private var itemType: ItemType = .item
    @State private var tags: [String] = []
    let parentID: UUID?
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(itemName.isEmpty)
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = InventoryItem(
            itemName: itemName,
            itemType: itemType,
            tags: tags,
            parentID: parentID
        )
        modelContext.insert(newItem)
        dismiss()
    }
}

#Preview {
    NewInventoryItemView(parentID: nil)
        .modelContainer(for: InventoryItem.self)
}
