import SwiftData
import SwiftUI

struct ItemDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: InventoryItem
    @State private var showingEditSheet = false
    @State private var showingTagEditor = false
    @State private var showingDebugView = false

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: item.isContainer ? "folder" : "doc")
                        .foregroundStyle(item.isContainer ? .blue : .gray)
                    Text(item.itemName)
                        .font(.headline)
                }

                if let parentID = item.parentID,
                    let parent = try? modelContext.fetch(
                        FetchDescriptor<InventoryItem>(
                            predicate: PredicateHelper.basicParentPredicate(parentId: parentID)
                        )
                    ).first
                {
                    NavigationLink {
                        ContainerView(container: parent)
                    } label: {
                        LabeledContent("Container", value: parent.itemName)
                    }
                }
            }

            // ... rest of the view remains the same ...
        }
        .navigationTitle("Item Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                ItemEditView(item: item)
            }
        }
        .sheet(isPresented: $showingTagEditor) {
            NavigationStack {
                TagEditorView(item: item)
            }
        }
        .sheet(isPresented: $showingDebugView) {
            NavigationStack {
                ItemDebugView(item: item)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)

    let context = container.mainContext
    let item = InventoryItem(itemName: "Test Item", isContainer: false)
    item.tags = ["test", "sample"]
    context.insert(item)

    return NavigationStack {
        ItemDetailView(item: item)
    }
    .modelContainer(container)
}
