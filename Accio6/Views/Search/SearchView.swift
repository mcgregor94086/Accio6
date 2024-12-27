import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""
    @State private var showingFilters = false
    @State private var selectedFilter: SearchFilter = .all
    
    var body: some View {
        NavigationStack {
            QueryResultsView(searchText: searchText)
                .searchable(text: $searchText, prompt: "Search items")
                .navigationTitle("Search")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingFilters = true
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
                .confirmationDialog("Filter Results", isPresented: $showingFilters) {
                    Button("All Items") {
                        selectedFilter = .all
                    }
                    Button("Containers Only") {
                        selectedFilter = .containers
                    }
                    Button("Items Only") {
                        selectedFilter = .items
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Show:")
                }
        }
    }
}

enum SearchFilter {
    case all
    case containers
    case items
}

#Preview {
    SearchView()
        .modelContainer(for: InventoryItem.self, inMemory: true)
}
