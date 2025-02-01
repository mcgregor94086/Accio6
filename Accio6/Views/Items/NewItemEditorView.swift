import SwiftUI
import SwiftData

struct NewItemEditorView: View {
    let parentID: UUID?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var itemName = ""
    @State private var itemType: ItemType = .item
    @State private var tags = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $itemName)
                Picker("Type", selection: $itemType) {
                    ForEach(ItemType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                            .tag(type)
                    }
                }
                TextField("Tags (comma separated)", text: $tags)
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
        let tagArray = tags.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let newItem = InventoryItem(
            itemName: itemName,
            itemType: itemType,
            tags: tagArray,
            parentID: parentID
        )
        
        modelContext.insert(newItem)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NewItemEditorView(parentID: nil)
        .modelContainer(for: InventoryItem.self, inMemory: true)
}
