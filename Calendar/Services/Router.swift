//
//  Router.swift
//  Calendar
//
//  Created by Admin on 22.01.2021.
//

import Foundation
import UIKit


protocol RouterProtocol {
    
    func pushCreateTaskScreen(date: Date?)
    func pushDescriptionTaskScreen(task: Task)
    func popViewController()
}

class Router: RouterProtocol{
    
    private var navigationController: UINavigationController
    private let serviceLayer = ServiceLayer()
    
    private lazy var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    
    func startFlow() {
        
        guard let calendarViewController = storyboard.instantiateViewController(
            withIdentifier: "CalendarViewController"
        ) as? CalendarViewController else { return }
        
        let presenter = CalendarPresenter(
            viewController: calendarViewController, serviceLayer: serviceLayer, router: self
        )
        calendarViewController.setPresenter(presenter: presenter)
        
        self.navigationController.setViewControllers([calendarViewController], animated: false)
        
    }
    
    
    func pushCreateTaskScreen(date: Date?) {
        
        guard let createTaskViewController = storyboard.instantiateViewController(
            withIdentifier: "CreateTaskViewController"
        ) as? CreateTaskViewController else { return }
        
        let createTaskPresenter = CreateTaskPresenter(viewController: createTaskViewController, serviceLayer: serviceLayer, router: self)
        createTaskViewController.setPresenter(presenter: createTaskPresenter)
        
        self.navigationController.pushViewController(createTaskViewController, animated: true)
        guard date != nil else { return }
        createTaskViewController.transmittedDate = date!
        
    }
    
    func pushDescriptionTaskScreen(task: Task) {
        guard let descriptionViewController = storyboard.instantiateViewController(withIdentifier: "DescriptionViewController") as? DescriptionViewController else { return }
        
        let descriptionPresenter = DescriptionPresenter(descriptionView: descriptionViewController)
        
        descriptionViewController.setPresenter(presenter: descriptionPresenter)
        descriptionViewController.transmittedTitle = task.name
        descriptionViewController.transmittedDescription = task.description
        descriptionViewController.transmittedDate = descriptionPresenter.getDateInString(date: task.date!)
        descriptionViewController.transmittedTime = descriptionPresenter.getTimeInString(date: task.date!)
        
        self.navigationController.pushViewController(descriptionViewController, animated: true)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
}

