//
//  DescriptionPresenter.swift
//  Calendar
//
//  Created by Admin on 10.02.2021.
//

import Foundation

protocol DescriptionPresenterProtocol {
    
}

class DescriptionPresenter: DescriptionPresenterProtocol {
    private var descriptionView: DescriptionViewProtocol
    private let calendar = Calendar.current
    
    init(descriptionView: DescriptionViewProtocol) {
        self.descriptionView = descriptionView
    }
    
    func getDateInString(date: Date) -> String {
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(day)-\(month)-\(year)"
    }
    func getTimeInString(date: Date) -> String {
        let hour = calendar.component(.hour, from: date)
        return "\(hour):00"
    }
}
