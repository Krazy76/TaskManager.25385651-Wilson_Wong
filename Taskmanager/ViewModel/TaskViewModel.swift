//
//  TaskViewModel.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation
import SwiftUI
import Combine

class TaskListViewModel: ObservableObject, TaskListManageable {
    @Published var tasks: [Task] = []
    @Published var filteredTasks: [Task] = []
    @Published var selectedCategory: TaskCategory? = nil
    @Published var searchText: String = "" {
        didSet { filterTasks() }
    }
    @Published var showCompleted: Bool = true {
        didSet { filterTasks() }
    }
    @Published var sortBy: TaskSortOption = .dueDate {
        didSet { sortTasks() }
    }
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let persistenceManager: TaskPersistenceManager
    
    enum TaskSortOption: String, CaseIterable {
        case dueDate = "Due Date"
        case priority = "Priority"
        case title = "Title"
        case createdDate = "Created Date"
    }
    
    init(persistenceManager: TaskPersistenceManager = TaskPersistenceManager()) {
        self.persistenceManager = persistenceManager
        loadTasks()
    }
// tasklistmanageble implementaion
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTask(task)
        filterTasks()
        sortTasks()
    }
    
    func removeTask(withId id: UUID) throws {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            throw TaskError.taskNotFound
        }
        let task = tasks[index]
        tasks.remove(at: index)
        
        do {
            try task.delete()
            try persistenceManager.deleteTask(withId: id)
        } catch {
            tasks.insert(task, at: index)
            throw TaskError.deleteFailed
        }
        
        filterTasks()
    }
    
    func updateTask(_ task: Task) throws {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            throw TaskError.taskNotFound
        }
        
        do {
            try task.validate()
            tasks[index] = task
            try task.save()
            try persistenceManager.updateTask(task)
        } catch {
            throw error
        }
        
        filterTasks()
        sortTasks()
    }
    
    func getTask(withId id: UUID) -> Task? {
        return tasks.first { $0.id == id }
    }
    
    func getAllTasks() -> [Task] {
        return tasks
    }
    
    func getTasksByCategory(_ category: TaskCategory) -> [Task] {
        return tasks.filter { $0.category == category }
    }
    
    func getCompletedTasks() -> [Task] {
        return tasks.filter { $0.isCompleted }
    }
    
    func getPendingTasks() -> [Task] {
        return tasks.filter { !$0.isCompleted }
    }
    
   // private methods to help promote encapsulation
    private func loadTasks() {
        isLoading = true
        do {
            tasks = try persistenceManager.loadTasks()
            filterTasks()
            sortTasks()
        } catch {
            errorMessage = "Failed to load tasks: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    private func saveTask(_ task: Task) {
        do {
            try task.save()
            try persistenceManager.saveTask(task)
        } catch {
            errorMessage = "Failed to save task: \(error.localizedDescription)"
        }
    }
    
    private func filterTasks() {
        var filtered = tasks
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !showCompleted {
            filtered = filtered.filter { !$0.isCompleted }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.description?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        filteredTasks = filtered
        sortTasks()
    }
    
    private func sortTasks() {
        switch sortBy {
        case .dueDate:
            filteredTasks.sort {
                guard let date1 = $0.dueDate, let date2 = $1.dueDate else {
                    return $0.dueDate != nil
                }
                return date1 < date2
            }
        case .priority:
            filteredTasks.sort { $0.priority.sortOrder > $1.priority.sortOrder }
        case .title:
            filteredTasks.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .createdDate:
            filteredTasks.sort { $0.createdDate > $1.createdDate }
        }
    }
}
