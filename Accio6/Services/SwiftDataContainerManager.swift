import Foundation
import SwiftData

class SwiftDataContainerManager {
    static func createContainer() throws -> ModelContainer {
        let schema = Schema([
            InventoryItem.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        let container = try ModelContainer(
            for: InventoryItem.self,
            configurations: modelConfiguration
        )
        
        return container
    }
    
    static func createPreviewContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: InventoryItem.self, configurations: config)
    }
}
