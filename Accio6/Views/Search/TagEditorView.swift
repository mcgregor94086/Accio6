import SwiftUI
import SwiftData

struct TagEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: InventoryItem
    
    @State private var newTag = ""
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("New Tag", text: $newTag)
                        .onSubmit {
                            addTag()
                        }
                }
                
                Section {
                    if item.tags.isEmpty {
                        Text("No tags")
                            .foregroundStyle(.secondary)
                            .italic()
                    } else {
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        removeTag(tag)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                } header: {
                    Text("Tags")
                }
            }
            .navigationTitle("Edit Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        addTag()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .disabled(newTag.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingError, presenting: errorMessage) { _ in
                Button("OK") { }
            } message: { message in
                Text(message)
            }
        }
    }
    
    private func addTag() {
        let tag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !tag.isEmpty else { return }
        
        if !item.tags.contains(tag) {
            item.tags.append(tag)
            try? modelContext.save()
        }
        
        newTag = ""
    }
    
    private func removeTag(_ tag: String) {
        if let index = item.tags.firstIndex(of: tag) {
            item.tags.remove(at: index)
            try? modelContext.save()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let item = InventoryItem(itemName: "Test Item")
    return TagEditorView(item: item)
        .modelContainer(container)
}
