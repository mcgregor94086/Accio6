import SwiftUI
import SwiftData

struct InventoryDebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \InventoryItem.itemName) private var allItems: [InventoryItem]
    @State private var selectedItem: InventoryItem?
    
    var body: some View {
        List {
            Section("All Items (\(allItems.count))") {
                ForEach(allItems) { item in
                    NavigationLink {
                        ItemDebugView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            LabeledValue(label: "Name", value: item.itemName)
                            Group {
                                LabeledValue(label: "Type", value: item.itemType.rawValue)
                                LabeledValue(label: "ID", value: item.id.uuidString)
                                if let parentID = item.parentID,
                                   let parent = try? modelContext.fetch(
                                    FetchDescriptor<InventoryItem>(
                                        predicate: PredicateHelper.parentPredicate(id: parentID)
                                    )
                                   ).first {
                                    LabeledValue(label: "Parent", value: parent.itemName)
                                }
                            }
                            .font(.caption)
                            
                            if item.itemType == .container {
                                let children = fetchChildren(for: item)
                                LabeledValue(label: "Children", value: "\(children.count) items")
                                    .font(.caption)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Inventory Debug")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    exportDebugData()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
    
    private func fetchChildren(for item: InventoryItem) -> [InventoryItem] {
        let descriptor = FetchDescriptor<InventoryItem>(
            predicate: PredicateHelper.childrenPredicate(parentId: item.id)
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func exportDebugData() {
        var debugOutput = "Inventory Debug Export\n"
        debugOutput += "=====================\n\n"
        
        for item in allItems {
            debugOutput += "Item: \(item.itemName)\n"
            debugOutput += "  ID: \(item.id.uuidString)\n"
            debugOutput += "  Type: \(item.itemType.rawValue)\n"
            if let parentID = item.parentID,
               let parent = try? modelContext.fetch(
                FetchDescriptor<InventoryItem>(
                    predicate: PredicateHelper.parentPredicate(id: parentID)
                )
               ).first {
                debugOutput += "  Parent: \(parent.itemName) (ID: \(parent.id.uuidString))\n"
            } else {
                debugOutput += "  Parent: None\n"
            }
            
            let children = fetchChildren(for: item)
            if item.itemType == .container {
                debugOutput += "  Children (\(children.count)):\n"
                for child in children {
                    debugOutput += "    - \(child.itemName) (ID: \(child.id.uuidString))\n"
                }
            }
            debugOutput += "\n"
        }
        
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent("inventory_debug.txt")
        try? debugOutput.write(to: tmpURL, atomically: true, encoding: .utf8)
        
        let activityVC = UIActivityViewController(
            activityItems: [tmpURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    NavigationStack {
        InventoryDebugView()
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
