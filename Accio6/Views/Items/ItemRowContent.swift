import SwiftUI
import SwiftData
import AVFoundation // For playing sounds

struct ItemRowContent: View {
    let item: InventoryItem
    let allItems: [InventoryItem]
    @Binding var expandedItems: Set<UUID>
    @Binding var showingAlert: Bool
    @Binding var selectedItem: InventoryItem?
    var onDelete: (InventoryItem) -> Void

    var childCount: Int {
        allItems.filter { $0.parentID == item.id }.count
    }

    var body: some View {
        HStack {
            Image(systemName: item.itemType == .container ? "folder.fill" : "doc.fill")
                .foregroundStyle(item.itemType == .container ? .blue : .secondary)
            
  
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.body)
                if childCount > 0 {
                    Text("\(childCount) items")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Use contextMenu instead of separate buttons
            Menu {
                if item.itemName != "My Stuff" {
                    Button(role: .destructive) {
                        onDelete(item)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                Button {
                    selectedItem = item
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }

    private func toggleExpansion() {
        if expandedItems.contains(item.id) {
            expandedItems.remove(item.id)
        } else {
            expandedItems.insert(item.id)
        }
    }

    private func playErrorSound() {
        AudioServicesPlaySystemSound(SystemSoundID(1053)) // Play error sound
    }
}
