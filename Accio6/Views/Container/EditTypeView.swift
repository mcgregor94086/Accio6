import SwiftUI
import SwiftData

/// View for editing the type of an inventory item
struct EditTypeView: View {
    // MARK: - Properties
    @Binding var item: InventoryItem
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Type", selection: $item.itemType) {
                        ForEach(InventoryItemType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } footer: {
                    Text("Choose whether this item can contain other items.")
                }
            }
            .navigationTitle("Edit Type")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider
#Preview("Edit Type") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let item = InventoryItem(itemName: "Test Item", itemType: .item)
    
    return EditTypeView(item: .constant(item))
        .modelContainer(container)
} 