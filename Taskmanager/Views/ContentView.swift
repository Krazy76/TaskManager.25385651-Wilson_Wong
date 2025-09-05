//
//  ContentView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var showingAddTask = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                TaskListView(viewModel: viewModel)
//                SearchAndFilterView(viewModel: viewModel)
                Spacer()
            }
            .navigationTitle("My Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

#Preview {
    ContentView()
}
