//
//  TaskCategory.swift
//  Taskmanager
//
//  Created by Wong Wilson on 5/9/2025.
//

import Foundation
import SwiftUI

enum TaskCategory: String, CaseIterable, Codable {
    case personal = "Personal"
    case work = "Work"
    case shopping = "Shopping"
    case health = "Health"
    case finance = "Finance"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .shopping: return "cart.fill"
        case .health: return "heart.fill"
        case .finance: return "dollarsign.circle.fill"
        case .other: return "folder.fill"
        }
    }
}
