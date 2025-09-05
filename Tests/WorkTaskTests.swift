//
//  WorkTaskTests.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import XCTest
@testable import Taskmanager

class WorkTaskTests: XCTestCase {
    
    func testWorkTaskInitialization() {
        let workTask = WorkTask(
            title: "Work Task",
            description: "Work Description",
            projectName: "Project Alpha",
            estimatedHours: 5.5
        )
        
        XCTAssertEqual(workTask.title, "Work Task")
        XCTAssertEqual(workTask.description, "Work Description")
        XCTAssertEqual(workTask.category, .work)
        XCTAssertEqual(workTask.projectName, "Project Alpha")
        XCTAssertEqual(workTask.estimatedHours, 5.5)
    }
    
    func testWorkTaskInheritance() {
        let workTask = WorkTask(title: "Test Work Task")
        
        XCTAssertFalse(workTask.isCompleted)
        workTask.markAsCompleted()
        XCTAssertTrue(workTask.isCompleted)
        
        XCTAssertNoThrow(try workTask.validate())
    }
}
