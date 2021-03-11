//
//  CreateTaskViewController.swift
//  Calendar
//
//  Created by Admin on 24.01.2021.
//

import Foundation
import UIKit

protocol CreateTaskViewProtocol {
    
}

class CreateTaskViewController: UIViewController, UITextFieldDelegate, CreateTaskViewProtocol{
    
    private var presenter: CreateTaskPresenterProtocol!
    var transmittedDate: Date?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var warnLabel: UILabel!
    
    
    @IBAction func didChangeValueDatePicker(_ sender: Any) {
        self.presenter.removeAllObservers()
        self.presenter.observerDailyTasksList(date: self.datePicker.date)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        guard titleTextField.text != "", descriptionTextField.text != "" else {
            showWarnLabel(text: "Please fill TextFields")
            return
        }
        guard self.presenter.isTimeFree(date: datePicker.date) else {
            showWarnLabel(text: "This time is busy")
            return
        }
        
        let dateStart = self.datePicker.date
        
        self.presenter.createNewTask(name: titleTextField.text!, description: descriptionTextField.text!, dateStart: dateStart)
        self.presenter.popViewController()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        self.descriptionTextField.delegate = self
        self.presenter.observerDailyTasksList(date: datePicker.date)
        warnLabel.alpha = 0
        guard transmittedDate != nil else { return }
        self.datePicker.date = transmittedDate!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter.removeAllObservers()
    }
    
    private func showWarnLabel(text: String) {
        self.warnLabel.text = text
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .autoreverse) {
            self.warnLabel.alpha = 1
        } completion: { [weak self] (completion) in
            self?.warnLabel.alpha = 0
        }
    }
    func setPresenter(presenter: CreateTaskPresenter) {
        self.presenter = presenter
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
