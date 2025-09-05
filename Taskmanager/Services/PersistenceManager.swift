//
//  PersistenceManager.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation

class TaskPersistenceManager {
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "SavedTasks"
    
    func saveTask(_ task: Task) throws {
        var tasks = try loadTasks()
        
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        
        let data = try JSONEncoder().encode(tasks)
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func loadTasks() throws -> [Task] {
        guard let data = userDefaults.data(forKey: tasksKey) else {
            return []
        }
        return try JSONDecoder().decode([Task].self, from: data)
    }
    
    func deleteTask(withId id: UUID) throws {
        var tasks = try loadTasks()
        tasks.removeAll { $0.id == id }
        
        let data = try JSONEncoder().encode(tasks)
        userDefaults.set(data, forKey: tasksKey)
    }
    
    func updateTask(_ task: Task) throws {
        try saveTask(task)
    }
}
