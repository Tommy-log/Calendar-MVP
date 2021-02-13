//
//  ServisLayer.swift
//  Calendar
//
//  Created by Admin on 23.01.2021.
//

import Foundation
import Firebase


protocol ServiceLayerProtocol {
    func addTaskForDate(task: Task, date: String)
    func removeAllObservers()
    func removeValue(task: Task?)
}

class ServiceLayer: ServiceLayerProtocol {
    private let calendar = Calendar.current
    private let reference: DatabaseReference
    
    
    init() {
        self.reference = Database.database().reference(withPath: "Tasks")
    }
    
    func addTaskForDate(task: Task, date: String) {
        
        let intervalStart = task.date!.timeIntervalSince1970
        let nsNumber = NSNumber(value: intervalStart)
        
        let dateReference = reference.child(date).child(task.name.lowercased())
        dateReference.setValue([
            "name" : task.name, "description" : task.description,
            "datestart" : nsNumber, "datefinish" : nsNumber
        ])
    }
    
    func removeAllObservers() {
        self.reference.removeAllObservers()
    }
    
    func removeValue(task: Task?) {
        guard let taskReference = task?.reference else { return }
        taskReference.removeValue()
    }
}
