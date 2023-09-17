//
//  Task.swift
//  Tasks
//
//  Created by 1234 on 16.09.2023.
//

import Foundation

enum TaskPriority {
    case normal
    case important
}

enum TaskStatus: Int {
    case planned
    case completed
}

struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
    
}
