import SwiftUI
import SwiftData

struct ItemDebugView: View {
    @Environment(\.modelContext) private var modelContext
    let item: InventoryItem
    
    var body: some View {
        List {
            Section("Basic Info") {
                LabeledContent("Name", value: item.itemName)
                LabeledContent("ID", value: item.id.uuidString)
                LabeledContent("Type", value: item.itemType.rawValue)
            }
            
            Section("Relationships") {
                if let parentID = item.parentID {
                    let descriptor = FetchDescriptor<InventoryItem>()
                    descriptor.predicate = #Predicate<InventoryItem> {
                        $0.id == parentID
                    }
                    if let parent = try? modelContext.fetch(descriptor).first {
                        LabeledContent("Parent", value: parent.itemName)
                    }
                } else {
                    Text("No parent (root item)")
                        .foregroundStyle(.secondary)
                }
                
                LabeledContent("Child Count", value: "\(item.childCount)")
            }
            
            if !item.tags.isEmpty {
                Section("Tags") {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
            }
            
            Section("Debug") {
                Text(item.debugDescription)
                    .font(.system(.body, design: .monospaced))
            }
            
            Section("Hierarchy") {
                Text(item.hierarchyDescription)
                    .font(.system(.body, design: .monospaced))
            }
        }
        .navigationTitle("Debug Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    let context = container.mainContext
    let item = InventoryItem(itemName: "Test Item")
    item.tags = ["test", "debug"]
    context.insert(item)
    
    return NavigationStack {
        ItemDebugView(item: item)
    }
    .modelContainer(container)
}
