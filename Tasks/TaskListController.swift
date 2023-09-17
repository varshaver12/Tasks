//
//  TaskListController.swift
//  Tasks
//
//  Created by 1234 on 16.09.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    let taskStorage: TaskStorageProtocol = TaskStorage()
    var tasks: [TaskPriority:[TaskProtocol]] = [:]
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let taskType = sectionsTypesPosition[section]
        guard let currentTaskType = tasks[taskType] else {
            return 0
        }
        return currentTaskType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getConfigureTaskCellConstraints(for: indexPath)
    }

    private func loadTasks() {
        sectionsTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        taskStorage.loadTasks().forEach { task in
            tasks[task.type]?.append(task)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let taskType = sectionsTypesPosition[section]
        switch taskType {
        case .important:
            return "Важные"
        case .normal:
            return "Текущие"
        }
    }
    
    // MARK: Private functions
    
    private func getConfigureTaskCellConstraints(for indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        textLabel?.text = currentTask.title
        
        if currentTask.status == .planned {
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }
        
        return cell
    }
    
    private func getSymbolForTask(with status: TaskStatus) -> String {
        switch status {
        case .planned:
            return "\u{25CB}"
        case .completed:
            return "\u{25C9}"
        }
    }

}
