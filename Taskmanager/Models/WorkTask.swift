//
//  WorkTask.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation
import Combine

class WorkTask: Task {
    @Published var projectName: String?
    @Published var estimatedHours: Double?
    
    init(title: String,
         description: String? = nil,
         dueDate: Date? = nil,
         priority: TaskPriority = .medium,
         projectName: String? = nil,
         estimatedHours: Double? = nil) {
        self.projectName = projectName
        self.estimatedHours = estimatedHours
        super.init(title: title, description: description, dueDate: dueDate, priority: priority, category: .work)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        projectName = try container.decodeIfPresent(String.self, forKey: .projectName)
        estimatedHours = try container.decodeIfPresent(Double.self, forKey: .estimatedHours)
        try super.init(from: decoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case projectName, estimatedHours
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(projectName, forKey: .projectName)
        try container.encodeIfPresent(estimatedHours, forKey: .estimatedHours)
    }
}
