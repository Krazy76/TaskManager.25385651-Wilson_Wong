//
//  TaskProtocol.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation

protocol TaskProtocol {
    var id: UUID { get }
    var title: String { get set }
    var description: String? { get set }
    var isCompleted: Bool { get set }
    var createdDate: Date { get }
    var dueDate: Date? { get set }
    var priority: TaskPriority { get set }
    var category: TaskCategory { get set }
    
    func markAsCompleted()
    func markAsIncomplete()
    func updateTitle(_ newTitle: String) throws
    func updateDescription(_ newDescription: String?)
}

protocol TaskValidatable {
    func validate() throws
}

protocol TaskPersistable {
    func save() throws
    func delete() throws
}

protocol TaskListManageable {
    var tasks: [Task] { get set }
    
    func addTask(_ task: Task)
    func removeTask(withId id: UUID) throws
    func updateTask(_ task: Task) throws
    func getTask(withId id: UUID) -> Task?
    func getAllTasks() -> [Task]
    func getTasksByCategory(_ category: TaskCategory) -> [Task]
    func getCompletedTasks() -> [Task]
    func getPendingTasks() -> [Task]
}
