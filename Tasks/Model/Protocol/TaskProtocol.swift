//
//  TaskProtocol.swift
//  Tasks
//
//  Created by 1234 on 16.09.2023.
//

import Foundation

protocol TaskProtocol {
    var title: String { get set }
    var type: TaskPriority { get set }
    var status: TaskStatus { get set }
}
