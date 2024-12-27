# View Examples Guidelines

## Main Views

### ContentView
![ContentView](Images/content_view.png)
1. Navigation Bar
   - Edit button (left)
   - Add Item button (right)
2. Search Bar
3. Item List
   - Shows root items
   - Supports deletion
4. Empty State
   - Shows when no items exist

### ContainerView
![ContainerView](Images/container_view.png)
1. Navigation Bar
   - Back button
   - Container name
   - Edit button
2. Container Info
   - Item count
   - Path display
3. Contents List
   - Nested items
   - Containers marked with icon
4. Action Buttons
   - Add Item
   - Sort Options

### ItemDetailView
![ItemDetailView](Images/item_detail.png)
1. Item Information
   - Name
   - Type
   - Location path
2. Tags Section
   - Tag editor
   - Tag suggestions
3. Actions
   - Move to Container
   - Delete Item
4. Debug Information (if enabled)

### SearchView
![SearchView](Images/search_view.png)
1. Search Bar
   - Real-time filtering
   - Search scope selector
2. Results List
   - Grouped by type
   - Shows location path
3. Filter Options
   - By type
   - By tags
4. No Results State

## Editor Views

### NewItemEditorView
![NewItemEditorView](Images/new_item_editor.png)
1. Form Fields
   - Name input
   - Type selector
   - Tags input
2. Location Selection
   - Current container
   - Container picker
3. Buttons
   - Cancel
   - Create

### ItemEditView
![ItemEditView](Images/item_edit.png)
Similar to NewItemEditorView but with:
1. Existing values pre-filled
2. Additional options based on item type
3. Delete capability
4. Move to container option

## Debug Views

### ItemDebugView
![ItemDebugView](Images/item_debug.png)
1. Basic Info Section
2. Relationships Section
3. Tags Section
4. Raw Data Section
5. Hierarchy Visualization