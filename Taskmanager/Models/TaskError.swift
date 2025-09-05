//
//  TaskError.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation

enum TaskError: LocalizedError {
    case emptyTitle
    case titleTooLong
    case invalidDueDate
    case taskNotFound
    case saveFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Task title cannot be empty"
        case .titleTooLong:
            return "Task title cannot exceed 100 characters"
        case .invalidDueDate:
            return "Due date cannot be in the past"
        case .taskNotFound:
            return "Task not found"
        case .saveFailed:
            return "Failed to save task"
        case .deleteFailed:
            return "Failed to delete task"
        }
    }
}
