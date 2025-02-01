//
//  ContainerTypes.swift
//  Accio6
//
//  Created by Scott McGregor on 1/13/25.
//

import Foundation

/// Defines the possible types of inventory items
enum InventoryItemType: String, CaseIterable {
    case container = "Container"
    case item = "Item"
    
    var icon: String {
        switch self {
        case .container: return "folder"
        case .item: return "doc"
        }
    }
} 
