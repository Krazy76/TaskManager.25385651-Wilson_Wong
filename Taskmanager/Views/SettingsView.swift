//
//  SettingsView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display Options")) {
                    Picker("Default Sort", selection: $viewModel.sortBy) {
                        ForEach(TaskListViewModel.TaskSortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    
                    Toggle("Show Completed Tasks", isOn: $viewModel.showCompleted)
                }
                
                Section(header: Text("Statistics")) {
                    StatisticsRowView(
                        title: "Total Tasks",
                        value: "\(viewModel.getAllTasks().count)"
                    )
                    
                    StatisticsRowView(
                        title: "Completed Tasks",
                        value: "\(viewModel.getCompletedTasks().count)"
                    )
                    
                    StatisticsRowView(
                        title: "Pending Tasks",
                        value: "\(viewModel.getPendingTasks().count)"
                    )
                    
                    let completionRate = viewModel.getAllTasks().isEmpty ? 0 :
                        (Double(viewModel.getCompletedTasks().count) / Double(viewModel.getAllTasks().count)) * 100
                    
                    StatisticsRowView(
                        title: "Completion Rate",
                        value: String(format: "%.1f%%", completionRate)
                    )
                }
                
                Section(header: Text("Categories")) {
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        let count = viewModel.getTasksByCategory(category).count
                        StatisticsRowView(
                            title: category.rawValue,
                            value: "\(count)",
                            icon: category.icon
                        )
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct StatisticsRowView: View {
    let title: String
    let value: String
    let icon: String?
    
    init(title: String, value: String, icon: String? = nil) {
        self.title = title
        self.value = value
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
            }
            
            Text(title)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
        }
    }
}
