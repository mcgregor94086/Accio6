import SwiftUI
import SwiftData

struct ParentEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var path: [UUID]
    let item: InventoryItem
    
    var body: some View {
        List {
            Section {
                if let parentID = item.parentID,
                   let parent = try? modelContext.fetch(
                    FetchDescriptor<InventoryItem>(
                        predicate: PredicateBuilder.parentPredicate(childID: parentID)
                    )
                   ).first {
                    NavigationLink(value: parent.id) {
                        ItemRow(item: parent)
                    }
                } else {
                    Text("No Parent")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Current Parent")
            }
            
            Section {
                Button("Move to Root") {
                    item.parentID = nil
                    try? modelContext.save()
                    if let id = item.id {
                        path = [id]
                    }
                    dismiss()
                }
            }
        }
        .navigationTitle("Select Parent")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ParentEditorView(
            path: .constant([]),
            item: InventoryItem(
                itemName: "Test Item",
                itemType: .item,
                tags: ["test"]
            )
        )
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
