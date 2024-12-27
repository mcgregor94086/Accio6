import SwiftUI
import SwiftData

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
                    Image(systemName: item.itemType == .container ? "folder" : "doc")
                        .foregroundStyle(item.itemType == .container ? .blue : .gray)
                    Text(item.itemName)
                        .font(.headline)
                }
                
                if let parentID = item.parentID,
                   let parent = try? modelContext.fetch(
                    FetchDescriptor<InventoryItem>(
                        predicate: PredicateHelper.basicParentPredicate(parentId: parentID)
                    )
                   ).first {
                    NavigationLink {
                        ContainerView(container: parent)
                    } label: {
                        LabeledContent("Container", value: parent.itemName)
                    }
                }
            }
            
            Section("Tags") {
                if item.tags.isEmpty {
                    Text("No tags")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(item.tags, id: \.self) { tag in
                        Text(tag)
                    }
                }
            }
            
            Section {
                Button {
                    showingTagEditor = true
                } label: {
                    Label("Edit Tags", systemImage: "tag")
                }
                
                Button {
                    showingEditSheet = true
                } label: {
                    Label("Edit Item", systemImage: "pencil")
                }
                
                if #available(iOS 17.0, *) {
                    Button {
                        showingDebugView = true
                    } label: {
                        Label("Debug Info", systemImage: "info.circle")
                    }
                }
            }
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
    let item = InventoryItem(itemName: "Test Item")
    item.tags = ["test", "sample"]
    context.insert(item)
    
    return NavigationStack {
        ItemDetailView(item: item)
    }
    .modelContainer(container)
}
