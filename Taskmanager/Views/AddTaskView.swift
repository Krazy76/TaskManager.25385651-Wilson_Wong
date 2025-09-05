//
//  AddTaskView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory = TaskCategory.personal
    @State private var selectedPriority = TaskPriority.medium
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var taskType: TaskType = .general
    
    @State private var projectName = ""
    @State private var estimatedHours = ""
    @State private var items = ""
    @State private var estimatedCost = ""
    @State private var store = ""
    
    enum TaskType: String, CaseIterable {
        case general = "General"
        case work = "Work"
        case shopping = "Shopping"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Task Title", text: $title)
                    TextField("Description (optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(TaskCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                        }
                    }
                    
                    Picker("Priority", selection: $selectedPriority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.rawValue)
                                .foregroundColor(priority.color)
                        }
                    }
                    
                    Toggle("Set Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Task Type")) {
                    Picker("Task Type", selection: $taskType) {
                        ForEach(TaskType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    switch taskType {
                    case .work:
                        TextField("Project Name (optional)", text: $projectName)
                        TextField("Estimated Hours (optional)", text: $estimatedHours)
                            .keyboardType(.decimalPad)
                        
                    case .shopping:
                        TextField("Items (comma separated)", text: $items, axis: .vertical)
                            .lineLimit(2...4)
                        TextField("Estimated Cost (optional)", text: $estimatedCost)
                            .keyboardType(.decimalPad)
                        TextField("Store (optional)", text: $store)
                        
                    case .general:
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        let task: Task
        
        switch taskType {
        case .work:
            task = WorkTask(
                title: title,
                description: description.isEmpty ? nil : description,
                dueDate: hasDueDate ? dueDate : nil,
                priority: selectedPriority,
                projectName: projectName.isEmpty ? nil : projectName,
                estimatedHours: Double(estimatedHours)
            )
            
        case .shopping:
            let itemList = items.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            task = ShoppingTask(
                title: title,
                description: description.isEmpty ? nil : description,
                dueDate: hasDueDate ? dueDate : nil,
                priority: selectedPriority,
                items: itemList,
                estimatedCost: Double(estimatedCost),
                store: store.isEmpty ? nil : store
            )
            
        case .general:
            task = Task(
                title: title,
                description: description.isEmpty ? nil : description,
                dueDate: hasDueDate ? dueDate : nil,
                priority: selectedPriority,
                category: selectedCategory
            )
        }
        
        do {
            try task.validate()
            viewModel.addTask(task)
            presentationMode.wrappedValue.dismiss()
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
    }
}
