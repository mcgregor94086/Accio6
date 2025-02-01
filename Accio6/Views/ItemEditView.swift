import SwiftUI
import SwiftData

struct ItemEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: InventoryItem
    @Query private var allItems: [InventoryItem]
    
    @State private var showingDeleteConfirmation = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var availableContainers: [InventoryItem] {
        allItems
            .filter { $0.isContainer && $0.id != item.id }
            .sorted { $0.itemName < $1.itemName }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $item.itemName)
                
                Picker("Type", selection: $item.isContainer) {
                    Text("Item").tag(false)
                    Text("Container").tag(true)
                }
                .pickerStyle(.segmented)
                
                if item.isContainer {
                    let childCount = item.childCount
                    LabeledContent("Contains", value: "\(childCount) item\(childCount == 1 ? "" : "s")")
                }
            }
            
            Section {
                Picker("Container", selection: $item.parentID) {
                    Text("No Container").tag(nil as UUID?)
                    ForEach(availableContainers) { container in
                        if container.canAddToContainer(item) {
                            Text(container.itemName).tag(container.id as UUID?)
                        }
                    }
                }
            } header: {
                Text("Location")
            }
            
            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Label("Delete Item", systemImage: "trash")
                }
                .disabled(!canDelete)
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
                Button("Done") {
                    save()
                }
            }
        }
        .alert("Error", isPresented: $showingError, presenting: errorMessage) { _ in
            Button("OK") { }
        } message: { message in
            Text(message)
        }
        .alert("Delete Item?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                delete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            if item.hasChildren {
                Text("This will also delete all items inside this container.")
            } else {
                Text("Are you sure you want to delete this item?")
            }
        }
    }
    
    // ... rest of the implementation remains the same ...
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let item = InventoryItem(itemName: "Test Item", isContainer: false)  // Updated initializer
    return NavigationStack {
        ItemEditView(item: item)
    }
    .modelContainer(container)
} 