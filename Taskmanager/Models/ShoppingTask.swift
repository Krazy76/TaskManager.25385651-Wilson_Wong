//
//  ShoppingTask.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation
import Combine

class ShoppingTask: Task {
    @Published var items: [String]
    @Published var estimatedCost: Double?
    @Published var store: String?
    
    init(title: String,
         description: String? = nil,
         dueDate: Date? = nil,
         priority: TaskPriority = .medium,
         items: [String] = [],
         estimatedCost: Double? = nil,
         store: String? = nil) {
        self.items = items
        self.estimatedCost = estimatedCost
        self.store = store
        super.init(title: title, description: description, dueDate: dueDate, priority: priority, category: .shopping)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([String].self, forKey: .items)
        estimatedCost = try container.decodeIfPresent(Double.self, forKey: .estimatedCost)
        store = try container.decodeIfPresent(String.self, forKey: .store)
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case items, estimatedCost, store
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
        try container.encodeIfPresent(estimatedCost, forKey: .estimatedCost)
        try container.encodeIfPresent(store, forKey: .store)
    }
}
