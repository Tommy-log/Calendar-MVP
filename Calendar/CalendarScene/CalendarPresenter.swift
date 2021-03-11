//
//  CalendarPresenter.swift
//  Calendar
//
//  Created by Admin on 23.01.2021.
//

import Firebase


protocol CalendarPresenterProtocol {
    
    func didSelectDate(date: Date)
    func deleteAllObservers()
    func getTitleForItem(row: Int) -> String
    func getTimeForItem(row: Int) -> String
    func didTapForCell(row: Int)
    func leadingSwipe(row: Int)
    func pushCreateTaskScreen()
    
}


class CalendarPresenter: CalendarPresenterProtocol {
    
    private let viewController: CalendarViewProtocol!
    private let serviceLayer: ServiceLayerProtocol!
    private let router: RouterProtocol!
    private let reference:DatabaseReference!
    private let calendar = Calendar.current
    private var dailyTaskList = [Task]()
    
    init(viewController: CalendarViewProtocol, serviceLayer: ServiceLayerProtocol, router: Router) {
        self.viewController = viewController
        self.serviceLayer = serviceLayer
        self.router = router
        self.reference = Database.database().reference(withPath: "Tasks")
        
    }
    
    
    func getTitleForItem(row: Int) -> String {
        
        let task = taskSelectionTheHour(row: row)
        guard task != nil else {
            return ""
        }
        return task!.name
    }
    
    func getTimeForItem(row: Int) -> String {
        return "\(row):00"
    }
    
    private func taskSelectionTheHour(row: Int) -> Task? {
        
        for task in dailyTaskList {
            let date = Date(timeIntervalSince1970: TimeInterval(truncating: task.dateStart))
            if calendar.component(.hour, from: date) == row {
                return task
            }
        }
        return nil
    }
    
    func didSelectDate(date: Date) {
        self.reference.removeAllObservers()
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dailyTasksReference = reference.child("\(day)-\(month)-\(year)")
        
        dailyTasksReference.observe(.value) { [weak self] (snapshot) in
            var tasks = Array<Task>()
            for item in snapshot.children {
                if let item = item as? DataSnapshot {
                    let task = Task(snapshot: item)
                    tasks.append(task)
                }
            }
            self?.dailyTaskList = self!.sortTasks(tasks: tasks)
            self?.viewController.reloadData()
        }
    }
    
    
    func deleteAllObservers() {
        self.serviceLayer.removeAllObservers()
    }
    
    private func sortTasks(tasks: [Task]) -> [Task] {
        
        return tasks.sorted { (task1, task2) -> Bool in
            let dateTask1 = Date(
                timeIntervalSince1970: TimeInterval(truncating: task1.dateStart)
            )
            let dateTask2 = Date(
                timeIntervalSince1970: TimeInterval(truncating: task2.dateStart)
            )
            return  self.calendar.component(.hour, from: dateTask1) < self.calendar.component(.hour, from: dateTask2)
        }
    }
    
    func didTapForCell(row: Int) {
        guard let task = taskSelectionTheHour(row: row) else {
            let date = prepareDateForPushCreateTaskScreen(row: row)
            self.router.pushCreateTaskScreen(date: date)
            return
        }
        self.router.pushDescriptionTaskScreen(task: task)
    }
    
    func leadingSwipe(row: Int) {
        self.serviceLayer.removeValue(task: taskSelectionTheHour(row: row))
        self.viewController.reloadData()
    }
    
    func pushCreateTaskScreen() {
        self.router.pushCreateTaskScreen(date: nil)
    }
    
    private func prepareDateForPushCreateTaskScreen(row: Int) -> Date {
        
        let datePickerDate = self.viewController.getDatePickerValue()
        let year = calendar.component(.year, from: datePickerDate)
        let month = calendar.component(.month, from: datePickerDate)
        let day = calendar.component(.day, from: datePickerDate)
        
        let timeZone = TimeZone.autoupdatingCurrent
        let hour = row
        let dateComponents = DateComponents(calendar: calendar, timeZone: timeZone, year: year, month: month, day: day, hour: hour)
        let date = dateComponents.date
        
        return date!
    }
}
