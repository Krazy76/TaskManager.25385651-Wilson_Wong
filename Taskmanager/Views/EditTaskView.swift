//
//  EditTaskView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var task: Task
    @ObservedObject var viewModel: TaskListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var description: String
    @State private var selectedCategory: TaskCategory
    @State private var selectedPriority: TaskPriority
    @State private var dueDate: Date
    @State private var hasDueDate: Bool
    
    init(task: Task, viewModel: TaskListViewModel) {
        self.task = task
        self.viewModel = viewModel
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description ?? "")
        self._selectedCategory = State(initialValue: task.category)
        self._selectedPriority = State(initialValue: task.priority)
        self._dueDate = State(initialValue: task.dueDate ?? Date())
        self._hasDueDate = State(initialValue: task.dueDate != nil)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
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
                    
                    Toggle("Has Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Actions")) {
                    Button(action: {
                        task.isCompleted.toggle()
                        saveChanges()
                    }) {
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                            Text(task.isCompleted ? "Mark as Incomplete" : "Mark as Complete")
                        }
                        .foregroundColor(task.isCompleted ? .orange : .green)
                    }
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        do {
            try task.updateTitle(title)
            task.updateDescription(description.isEmpty ? nil : description)
            task.category = selectedCategory
            task.priority = selectedPriority
            task.dueDate = hasDueDate ? dueDate : nil
            
            try viewModel.updateTask(task)
            presentationMode.wrappedValue.dismiss()
        } catch {
            viewModel.errorMessage = error.localizedDescription
        }
    }
}
