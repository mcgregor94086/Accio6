let parentID: UUID? = self.id
descriptor.predicate = #Predicate<InventoryItem> { item in
    item.parentID == parentID
}
