//
//  TaskStorage.swift
//  Tasks
//
//  Created by 1234 on 16.09.2023.
//

import Foundation

class TaskStorage: TaskStorageProtocol {
    func loadTasks() -> [TaskProtocol] {
        let testTasks = [
            Task(title: "Купить макбук", type: .normal, status: .completed),
            Task(title: "Покормить сгущенку", type: .important, status: .planned),
            Task(title: "Заказать еду", type: .normal, status: .planned),
            Task(title: "Сделать ремонт на кухне", type: .normal, status: .planned),
            Task(title: "Попить воды", type: .important, status: .completed)]
        return testTasks
    }
    
    func saveTasks(_ tasks: [TaskProtocol]) {
        // TODO: Реализовать функциональность сохранения
    }
    
    
}
