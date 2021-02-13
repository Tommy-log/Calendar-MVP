//
//  Task.swift
//  Calendar
//
//  Created by Admin on 23.01.2021.
//

import Foundation
import Firebase


struct Task {
    
    let dateStart: NSNumber
    var dateFinish: NSNumber?
    var date: Date?
    let name: String
    let description: String
    var reference: DatabaseReference?
    
    init(name: String, description: String, dateStart: NSNumber) {
        self.name = name
        self.description = description
        self.dateStart = dateStart
        self.dateFinish = dateStart
        self.reference = nil
        let timeInterval = dateStart
        date = Date(timeIntervalSince1970: TimeInterval(truncating: timeInterval))
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
      
        self.dateStart = snapshotValue["datestart"] as! NSNumber
        self.dateFinish = snapshotValue["datefinish"] as? NSNumber
        self.name = snapshotValue["name"] as! String
        self.description = snapshotValue["description"] as! String
        self.reference = snapshot.ref
        let timeInterval = dateStart
        date = Date(timeIntervalSince1970: TimeInterval(truncating: timeInterval))
    }
}
