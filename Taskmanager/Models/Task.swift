//
//  Task.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation
import SwiftUI
import Combine

class Task: ObservableObject, TaskProtocol, TaskValidatable, TaskPersistable, Identifiable, Codable {
    let id: UUID
    @Published var title: String
    @Published var description: String?
    @Published var isCompleted: Bool
    let createdDate: Date
    @Published var dueDate: Date?
    @Published var priority: TaskPriority
    @Published var category: TaskCategory
    
    init(title: String,
         description: String? = nil,
         dueDate: Date? = nil,
         priority: TaskPriority = .medium,
         category: TaskCategory = .personal) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.isCompleted = false
        self.createdDate = Date()
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
    }
    
    // codable implmentaion
    enum CodingKeys: String, CodingKey {
        case id, title, description, isCompleted, createdDate, dueDate, priority, category
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
        priority = try container.decode(TaskPriority.self, forKey: .priority)
        category = try container.decode(TaskCategory.self, forKey: .category)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
        try container.encode(priority, forKey: .priority)
        try container.encode(category, forKey: .category)
    }
    
    // Task protocol implementations
    func markAsCompleted() {
        isCompleted = true
    }
    
    func markAsIncomplete() {
        isCompleted = false
    }
    
    func updateTitle(_ newTitle: String) throws {
        guard !newTitle.isEmpty else {
            throw TaskError.emptyTitle
        }
        guard newTitle.count <= 100 else {
            throw TaskError.titleTooLong
        }
        title = newTitle
    }
    
    func updateDescription(_ newDescription: String?) {
        description = newDescription
    }
    
    // protocol taskvalidateble implemented
    func validate() throws {
        guard !title.isEmpty else {
            throw TaskError.emptyTitle
        }
        guard title.count <= 100 else {
            throw TaskError.titleTooLong
        }
        if let dueDate = dueDate, dueDate < Date() {
            throw TaskError.invalidDueDate
        }
    }
    
    // taskpersistable implementation
    func save() throws {
        print("Saving task: \(title)")
    }
    
    func delete() throws {
        print("Deleting task: \(title)")
    }
}
