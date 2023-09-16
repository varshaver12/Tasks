//
//  TaskStorageProtocol.swift
//  Tasks
//
//  Created by 1234 on 16.09.2023.
//

import Foundation

protocol TaskStorageProtocol {
    func loadTasks() -> [TaskProtocol]
    func saveTasks(_ tasks: [TaskProtocol])
}
