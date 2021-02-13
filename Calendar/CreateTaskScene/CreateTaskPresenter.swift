//
//  CreateTaskPresenter.swift
//  Calendar
//
//  Created by Admin on 27.01.2021.
//

import Firebase


protocol CreateTaskPresenterProtocol {
    func createNewTask(name: String, description: String, dateStart: Date)
    func observerDailyTasksList(date: Date)
    func removeAllObservers()
    func isTimeFree(date: Date) -> Bool
    func popViewController()
}


class CreateTaskPresenter: CreateTaskPresenterProtocol {
    
    private var viewController: CreateTaskViewProtocol!
    private var serviceLayer: ServiceLayerProtocol!
    private let calendar = Calendar.current
    private var router: RouterProtocol
    private let reference: DatabaseReference!
    private var dailyTasksList = [Task]()
    
    init(viewController: CreateTaskViewProtocol, serviceLayer: ServiceLayerProtocol, router: RouterProtocol) {
        
        self.viewController = viewController
        self.serviceLayer = serviceLayer
        self.router = router
        reference = Database.database().reference(withPath: "Tasks")
    }
    
    func createNewTask(name: String, description: String, dateStart: Date) {
        
        let interval = dateStart.timeIntervalSince1970
        let nsNumber = NSNumber(value: interval)
        
        let task = Task(name: name, description: description, dateStart: nsNumber)
        let day = calendar.component(.day, from: task.date!)
        let month = calendar.component(.month, from: task.date!)
        let year = calendar.component(.year, from: task.date!)
        let dateString = "\(day)-\(month)-\(year)"
        self.serviceLayer.addTaskForDate(task: task, date: dateString)
    
    }
    
    func observerDailyTasksList(date: Date) {
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dailyTasksListReference = reference.child("\(day)-\(month)-\(year)")

        dailyTasksListReference.observe(.value) { (snapshot) in
            var tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                tasks.append(task)
            }
            self.dailyTasksList = tasks
        }
    }
    
    func removeAllObservers() {
        self.reference.removeAllObservers()
    }
    
     func isTimeFree(date: Date) -> Bool {
        
        let hourNewDate = calendar.component(.hour, from: date)
        
        for task in dailyTasksList {
            let hour = calendar.component(.hour, from: task.date!)
            if hour == hourNewDate {
                return false
            }
        }
        return true
    }
    
    func popViewController() {
        self.router.popViewController()
    }
}
