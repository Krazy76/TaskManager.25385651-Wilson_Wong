//
//  EmptyStateView.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("No Tasks Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to create your first task")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
