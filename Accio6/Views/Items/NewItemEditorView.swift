import SwiftUI
import SwiftData

struct NewItemEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var allItems: [InventoryItem]
    
    @State private var itemName = ""
    @State private var itemType: InventoryItemType = .item
    @State private var selectedParentID: UUID?
    @State private var errorMessage: String?
    @State private var showingError = false
    
    let parentContainer: InventoryItem?
    
    init(parentContainer: InventoryItem? = nil) {
        self.parentContainer = parentContainer
        _selectedParentID = State(initialValue: parentContainer?.id)
    }
    
    var availableContainers: [InventoryItem] {
        allItems.filter { $0.itemType == .container }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Item Name", text: $itemName)
                
                Picker("Type", selection: $itemType) {
                    Text("Item").tag(InventoryItemType.item)
                    Text("Container").tag(InventoryItemType.container)
                }
                
                if parentContainer == nil {
                    Picker("Container", selection: $selectedParentID) {
                        Text("No Container").tag(nil as UUID?)
                        ForEach(availableContainers) { container in
                            Text(container.itemName).tag(container.id as UUID?)
                        }
                    }
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
            .alert("Error", isPresented: $showingError, presenting: errorMessage) { _ in
                Button("OK") { }
            } message: { message in
                Text(message)
            }
        }
    }
    
    private func addItem() {
        do {
            let newItem = InventoryItem(
                itemName: itemName,
                itemType: itemType,
                parentID: parentContainer?.id ?? selectedParentID
            )
            modelContext.insert(newItem)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save item: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    NewItemEditorView()
        .modelContainer(for: InventoryItem.self, inMemory: true)
}
