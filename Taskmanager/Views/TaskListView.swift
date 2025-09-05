//
//  TaskListView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView("Loading tasks...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.filteredTasks.isEmpty {
            EmptyStateView()
        } else {
            List {
                ForEach(viewModel.filteredTasks) { task in
                    TaskRowView(task: task, viewModel: viewModel)
                }
                .onDelete(perform: deleteTasks)
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            let task = viewModel.filteredTasks[index]
            do {
                try viewModel.removeTask(withId: task.id)
            } catch {
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }
}
