//
//  TaskmanagerTests.swift
//  TaskmanagerTests
//
//  Created by Wong Wilson on 5/9/2025.
//

import XCTest
@testable import Taskmanager

class TaskTests: XCTestCase {
    
    func testTaskInitialization() {
        let task = Task(title: "Test Task", description: "Test Description")
        
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.description, "Test Description")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.priority, .medium)
        XCTAssertEqual(task.category, .personal)
        XCTAssertNotNil(task.id)
        XCTAssertNotNil(task.createdDate)
    }
    
    func testTaskCompletion() {
        let task = Task(title: "Test Task")
        
        XCTAssertFalse(task.isCompleted)
        
        task.markAsCompleted()
        XCTAssertTrue(task.isCompleted)
        
        task.markAsIncomplete()
        XCTAssertFalse(task.isCompleted)
    }
    
    func testTaskValidation() {
        let task = Task(title: "Valid Task")
        
        XCTAssertNoThrow(try task.validate())
        
        task.title = ""
        XCTAssertThrowsError(try task.validate()) { error in
            XCTAssertEqual(error as? TaskError, TaskError.emptyTitle)
        }
        
        task.title = String(repeating: "a", count: 101)
        XCTAssertThrowsError(try task.validate()) { error in
            XCTAssertEqual(error as? TaskError, TaskError.titleTooLong)
        }
        
        task.title = "Valid Task"
        task.dueDate = Date().addingTimeInterval(-86400)
        XCTAssertThrowsError(try task.validate()) { error in
            XCTAssertEqual(error as? TaskError, TaskError.invalidDueDate)
        }
    }
    
    func testTaskTitleUpdate() {
        let task = Task(title: "Original Title")
        
        XCTAssertNoThrow(try task.updateTitle("New Title"))
        XCTAssertEqual(task.title, "New Title")
        
        XCTAssertThrowsError(try task.updateTitle("")) { error in
            XCTAssertEqual(error as? TaskError, TaskError.emptyTitle)
        }
        XCTAssertEqual(task.title, "New Title")
        
        let longTitle = String(repeating: "a", count: 101)
        XCTAssertThrowsError(try task.updateTitle(longTitle)) { error in
            XCTAssertEqual(error as? TaskError, TaskError.titleTooLong)
        }
        XCTAssertEqual(task.title, "New Title")
    }
}
