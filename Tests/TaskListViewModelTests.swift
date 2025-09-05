//
//  TaskListViewModelTests.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import XCTest
import Combine
@testable import Taskmanager

class TaskListViewModelTests: XCTestCase {
    var viewModel: TaskListViewModel!
    var mockPersistenceManager: MockTaskPersistenceManager!
    
    override func setUp() {
        super.setUp()
        mockPersistenceManager = MockTaskPersistenceManager()
        viewModel = TaskListViewModel(persistenceManager: mockPersistenceManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockPersistenceManager = nil
        super.tearDown()
    }
    
    func testAddTask() {
        let task = Task(title: "Test Task")
        let initialCount = viewModel.tasks.count
        
        viewModel.addTask(task)
        
        XCTAssertEqual(viewModel.tasks.count, initialCount + 1)
        XCTAssertTrue(viewModel.tasks.contains { $0.id == task.id })
        XCTAssertTrue(mockPersistenceManager.savedTasks.contains { $0.id == task.id })
    }
    
    func testRemoveTask() {
        let task = Task(title: "Test Task")
        viewModel.addTask(task)
        
        let initialCount = viewModel.tasks.count
        
        XCTAssertNoThrow(try viewModel.removeTask(withId: task.id))
        XCTAssertEqual(viewModel.tasks.count, initialCount - 1)
        XCTAssertFalse(viewModel.tasks.contains { $0.id == task.id })
    }
    
    func testRemoveNonExistentTask() {
        let nonExistentId = UUID()
        
        XCTAssertThrowsError(try viewModel.removeTask(withId: nonExistentId)) { error in
            XCTAssertEqual(error as? TaskError, TaskError.taskNotFound)
        }
    }
    
    func testUpdateTask() {
        let task = Task(title: "Original Title")
        viewModel.addTask(task)
        
        task.title = "Updated Title"
        
        XCTAssertNoThrow(try viewModel.updateTask(task))
        
        let retrievedTask = viewModel.getTask(withId: task.id)
        XCTAssertEqual(retrievedTask?.title, "Updated Title")
    }
    
    func testGetTasksByCategory() {
        let workTask = Task(title: "Work Task", category: .work)
        let personalTask = Task(title: "Personal Task", category: .personal)
        
        viewModel.addTask(workTask)
        viewModel.addTask(personalTask)
        
        let workTasks = viewModel.getTasksByCategory(.work)
        let personalTasks = viewModel.getTasksByCategory(.personal)
        
        XCTAssertEqual(workTasks.count, 1)
        XCTAssertEqual(personalTasks.count, 1)
        XCTAssertEqual(workTasks.first?.title, "Work Task")
        XCTAssertEqual(personalTasks.first?.title, "Personal Task")
    }
    
    func testGetCompletedTasks() {
        let completedTask = Task(title: "Completed Task")
        completedTask.markAsCompleted()
        
        let pendingTask = Task(title: "Pending Task")
        
        viewModel.addTask(completedTask)
        viewModel.addTask(pendingTask)
        
        let completed = viewModel.getCompletedTasks()
        let pending = viewModel.getPendingTasks()
        
        XCTAssertEqual(completed.count, 1)
        XCTAssertEqual(pending.count, 1)
        XCTAssertTrue(completed.first?.isCompleted ?? false)
        XCTAssertFalse(pending.first?.isCompleted ?? true)
    }
    
    func testSearchFiltering() {
        let task1 = Task(title: "Buy groceries", description: "Milk and bread")
        let task2 = Task(title: "Call dentist", description: "Schedule appointment")
        
        viewModel.addTask(task1)
        viewModel.addTask(task2)
        
        viewModel.searchText = "groceries"
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertEqual(viewModel.filteredTasks.first?.title, "Buy groceries")
        
        viewModel.searchText = "appointment"
        XCTAssertEqual(viewModel.filteredTasks.count, 1)
        XCTAssertEqual(viewModel.filteredTasks.first?.title, "Call dentist")
        
        viewModel.searchText = "nonexistent"
        XCTAssertEqual(viewModel.filteredTasks.count, 0)
        
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredTasks.count, 2)
    }
}

// MARK: - Mock Classes
class MockTaskPersistenceManager: TaskPersistenceManager {
    var savedTasks: [Task] = []
    var shouldThrowError = false
    
    override func saveTask(_ task: Task) throws {
        if shouldThrowError {
            throw TaskError.saveFailed
        }
        
        if let index = savedTasks.firstIndex(where: { $0.id == task.id }) {
            savedTasks[index] = task
        } else {
            savedTasks.append(task)
        }
    }
    
    override func loadTasks() throws -> [Task] {
        if shouldThrowError {
            throw TaskError.saveFailed
        }
        return savedTasks
    }
    
    override func deleteTask(withId id: UUID) throws {
        if shouldThrowError {
            throw TaskError.deleteFailed
        }
        savedTasks.removeAll { $0.id == id }
    }
    
    override func updateTask(_ task: Task) throws {
        if shouldThrowError {
            throw TaskError.saveFailed
        }
        try saveTask(task)
    }
}
