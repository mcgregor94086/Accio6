import SwiftUI
import SwiftData

struct ItemRowContent: View {
    @Environment(\.modelContext) private var modelContext
    let item: InventoryItem
    @State private var showingDebugInfo = false
    @State private var showingDeleteConfirmation = false
    @State private var showingError = false
    @State private var errorMessage: String?
    
    var body: some View {
        HStack {
            Image(systemName: item.itemType == .container ? "folder" : "doc")
                .foregroundStyle(item.itemType == .container ? .blue : .primary)
            
            VStack(alignment: .leading) {
                Text(item.itemName)
                
                if !item.tags.isEmpty {
                    Text(item.tags.joined(separator: ", "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if item.itemType == .container {
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .contentShape(Rectangle())
        .contextMenu {
            if item.itemType == .container {
                NavigationLink(value: item) {
                    Label("Open", systemImage: "folder")
                }
            }
            
            Button {
                showingDebugInfo = true
            } label: {
                Label("Show Debug Info", systemImage: "info.circle")
            }
            
            Button(role: .destructive) {
                showingDeleteConfirmation = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showingDebugInfo) {
            NavigationStack {
                InventoryItemDebugView(item: item)
            }
        }
        .alert("Delete Item", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteItem()
            }
        } message: {
            Text("Are you sure you want to delete this item? This cannot be undone.")
        }
        .alert("Error", isPresented: $showingError, presenting: errorMessage) { _ in
            Button("OK") { }
        } message: { message in
            Text(message)
        }
    }
    
    private func deleteItem() {
        do {
            if let itemID = item.id {
                let childrenDescriptor = FetchDescriptor<InventoryItem>(
                    predicate: PredicateBuilder.childrenPredicate(parentID: itemID)
                )
                if let children = try? modelContext.fetch(childrenDescriptor) {
                    for child in children {
                        modelContext.delete(child)
                    }
                }
            }
            
            modelContext.delete(item)
            try modelContext.save()
        } catch {
            errorMessage = "Failed to delete item: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    List {
        ItemRowContent(item: InventoryItem(
            itemName: "Test Item",
            itemType: .item,
            tags: ["test", "preview"]
        ))
        
        ItemRowContent(item: InventoryItem(
            itemName: "Test Container",
            itemType: .container,
            tags: ["test", "container"]
        ))
    }
    .modelContainer(for: InventoryItem.self, inMemory: true)
}
