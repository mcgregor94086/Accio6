import SwiftData
import SwiftUI

struct InventoryItemDebugView: View {
    @Environment(\.modelContext) private var modelContext
    let inventoryItem: InventoryItem

    // Make descriptor mutable by using var instead of let
    @State private var descriptor: String

    init(inventoryItem: InventoryItem) {
        self.inventoryItem = inventoryItem
        // Initialize the State property using _descriptor
        _descriptor = State(initialValue: "Initial description")
    }

    var body: some View {
        Form {
            Section("Basic Info") {
                LabeledContent("ID", value: inventoryItem.id)
                LabeledContent("Name", value: inventoryItem.itemName)
                LabeledContent("Type", value: inventoryItem.itemType.rawValue)
            }

            Section("Relationships") {
                if let parentId = inventoryItem.parentID {
                    LabeledContent("Parent ID", value: parentId)
                }
                LabeledContent("Children", value: "\(inventoryItem.children.count)")
            }

            Section("Debug Info") {
                TextField("Description", text: $descriptor)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let item = InventoryItem(itemName: "Debug Item")

    return InventoryItemDebugView(inventoryItem: item)
        .modelContainer(container)
}
