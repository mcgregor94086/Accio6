import SwiftUI
import SwiftData

@main
struct Accio6App: App {
    let container: ModelContainer
    
    init() {
        print("Starting app initialization")
        do {
            let schema = Schema([InventoryItem.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            print("Created configuration")
            container = try ModelContainer(for: schema, configurations: config)
            
            // Insert test data
            let context = container.mainContext
            let testContainer = InventoryItem(
                itemName: "Test Container",
                itemType: .container,
                tags: ["test"]
            )
            print("Created test container with ID: \(String(describing: testContainer.id))")
            context.insert(testContainer)
            
            let testItem = InventoryItem(
                itemName: "Test Item",
                itemType: .item,
                tags: ["test"],
                parentID: testContainer.id
            )
            print("Created test item with parentID: \(String(describing: testItem.parentID))")
            context.insert(testItem)
            
            try context.save()
            print("Saved context")
            
            // Verify data
            let descriptor = FetchDescriptor<InventoryItem>()
            if let items = try? context.fetch(descriptor) {
                print("\nAll items in database:")
                for item in items {
                    print("- \(item.itemName) (Type: \(item.itemType), ParentID: \(String(describing: item.parentID)))")
                }
            }
            
            print("Created container and inserted test data")
        } catch {
            print("Error creating container: \(error)")
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .onAppear {
                        print("ContentView appeared")
                    }
            }
        }
        .modelContainer(container)
    }
}
