//
//  TaskListController.swift
//  Tasks
//
//  Created by 1234 on 16.09.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    let taskStorage: TaskStorageProtocol = TaskStorage()
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
            for (taskGroupPriority, tasksGroup) in tasks {
                tasks[taskGroupPriority] = tasksGroup.sorted(by: { task1, task2 in
                    let task1Position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2Position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1Position < task2Position
                })
            }
        }
    }
    var sectionsTypesPosition: [TaskPriority] = [.important, .normal]
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]

    override func viewDidLoad() {
        super.viewDidLoad()

        loadTasks()
        navigationItem.leftBarButtonItem = editButtonItem
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
        //return getConfigureTaskCellConstraints(for: indexPath)
        return getConfigureTaskCellStack(for: indexPath)
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
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    // Удаление
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskType = sectionsTypesPosition[indexPath.section]
            tasks[taskType]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    // Функция перемещения строк по таблице
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let taskTypeFrom = sectionsTypesPosition[sourceIndexPath.section]
        let taskTypeTo = sectionsTypesPosition[destinationIndexPath.section]
        
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        tasks[taskTypeFrom]?.remove(at: sourceIndexPath.row)
        
        tasks[taskTypeTo]?.insert(movedTask, at: destinationIndexPath.row)
        
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]?[destinationIndexPath.row].type = taskTypeTo
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let taskType = sectionsTypesPosition[indexPath.section]
        if taskType == .normal {
            return true
        }
        return false
    }
    
    // MARK: - Table view delegate
    
    // Обработка нажатия на строку таблицы
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        guard tasks[taskType]?[indexPath.row].status == .planned else {
            // Снимаем выделение
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        tasks[taskType]?[indexPath.row].status = .completed
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        guard tasks[taskType]?[indexPath.row].status == .completed else {
            return nil
        }
        let actionSwipeInstance = UIContextualAction(style: .normal, title: "Не выполнена") { _, _, _ in
            self.tasks[taskType]?[indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [actionSwipeInstance])
    }
    
    // MARK: - Private functions
    
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
    
    private func getConfigureTaskCellStack(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        let taskType = sectionsTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        // Configure
        
        cell.title.text = currentTask.title
        cell.symbol.text = getSymbolForTask(with: currentTask.status)
        
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
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
