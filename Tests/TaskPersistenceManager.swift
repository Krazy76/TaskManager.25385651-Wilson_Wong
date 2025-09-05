//
//  TaskPersistenceManager.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import XCTest
@testable import Taskmanager

class TaskPersistenceManagerTests: XCTestCase {
    var persistenceManager: TaskPersistenceManager!
    let testKey = "TestTasks"
    
    override func setUp() {
        super.setUp()
        persistenceManager = TaskPersistenceManager()
        UserDefaults.standard.removeObject(forKey: testKey)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: testKey)
        persistenceManager = nil
        super.tearDown()
    }
    
    func testSaveAndLoadTasks() {
        let task1 = Task(title: "Task 1")
        let task2 = Task(title: "Task 2")
        
        XCTAssertNoThrow(try persistenceManager.saveTask(task1))
        XCTAssertNoThrow(try persistenceManager.saveTask(task2))
        
        XCTAssertNoThrow {
            let loadedTasks = try self.persistenceManager.loadTasks()
            XCTAssertEqual(loadedTasks.count, 2)
            
            let titles = loadedTasks.map { $0.title }
            XCTAssertTrue(titles.contains("Task 1"))
            XCTAssertTrue(titles.contains("Task 2"))
        }
    }
    
    func testDeleteTask() {
        let task = Task(title: "Task to Delete")
        
        XCTAssertNoThrow(try persistenceManager.saveTask(task))
        
        XCTAssertNoThrow {
            let loadedTasks = try self.persistenceManager.loadTasks()
            XCTAssertEqual(loadedTasks.count, 1)
        }
        
        XCTAssertNoThrow(try persistenceManager.deleteTask(withId: task.id))
        
        XCTAssertNoThrow {
            let loadedTasks = try self.persistenceManager.loadTasks()
            XCTAssertEqual(loadedTasks.count, 0)
        }
    }
    
    func testLoadEmptyTasks() {
        XCTAssertNoThrow {
            let loadedTasks = try self.persistenceManager.loadTasks()
            XCTAssertTrue(loadedTasks.isEmpty)
        }
    }
}
