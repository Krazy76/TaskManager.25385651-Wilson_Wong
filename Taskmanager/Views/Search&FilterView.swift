//
//  Search&FilterView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//
import SwiftUI

struct SearchAndFilterView: View {
    @ObservedObject var viewModel: TaskListViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search tasks...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            
            HStack {
                Picker("Category", selection: $viewModel.selectedCategory) {
                    Text("All Categories").tag(TaskCategory?.none)
                    ForEach(TaskCategory.allCases, id: \.self) { category in
                        Label(category.rawValue, systemImage: category.icon)
                            .tag(TaskCategory?.some(category))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                
                Picker("Sort", selection: $viewModel.sortBy) {
                    ForEach(TaskListViewModel.TaskSortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                
                Toggle("Completed", isOn: $viewModel.showCompleted)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground))
    }
}
