//
//  InventoryItemType 3.swift
//  Accio6
//
//  Created by Scott McGregor on 1/20/25.
//


import Foundation

public enum InventoryItemType: String, Codable, CaseIterable {
    case item = "Item"
    case container = "Container"
}