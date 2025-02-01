import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [InventoryItem]
    
    @State private var searchText = ""
    @State private var selectedTypes: Set<ItemType> = []
    @State private var selectedTags: Set<String> = []
    @State private var showFilters = false
    
    init() {
        let predicate = #Predicate<InventoryItem> { item in
            item.itemName.localizedStandardContains(searchText)
        }
        self._items = Query(filter: predicate, sort: \InventoryItem.itemName)
    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    InventoryItemRow(item: item)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search items")
        .navigationTitle("Search")
        .navigationDestination(for: InventoryItem.self) { item in
            ItemDetailView(item: item)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showFilters.toggle()
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(isPresented: $showFilters) {
            NavigationStack {
                FilterView(selectedTypes: $selectedTypes, selectedTags: $selectedTags)
            }
        }
    }
}

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTypes: Set<ItemType>
    @Binding var selectedTags: Set<String>
    
    var body: some View {
        Form {
            Section("Item Type") {
                ForEach(ItemType.allCases, id: \.self) { type in
                    Toggle(type.rawValue.capitalized, isOn: binding(for: type))
                }
            }
            
            Section("Tags") {
                // TODO: Implement tag selection
                Text("Tag selection coming soon")
            }
        }
        .navigationTitle("Filters")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    private func binding(for type: ItemType) -> Binding<Bool> {
        Binding(
            get: { selectedTypes.contains(type) },
            set: { isSelected in
                if isSelected {
                    selectedTypes.insert(type)
                } else {
                    selectedTypes.remove(type)
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .modelContainer(for: InventoryItem.self)
}
