//
//  ViewController.swift
//  Calendar
//
//  Created by Admin on 22.01.2021.
//

import UIKit

protocol CalendarViewProtocol {
    func getDatePickerValue() -> Date
    func reloadData()
}

class CalendarViewController: UIViewController, CalendarViewProtocol{
    
    private var presenter: CalendarPresenterProtocol!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapAddButton(_ sender: Any) {
        self.presenter.pushCreateTaskScreen()
    }
    
    @IBAction func didChangeValueDatePicker(_ sender: Any) {
        self.presenter.didSelectDate(date: self.datePicker.date)
    }
    
// MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tableViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.didSelectDate(date: self.datePicker.date)
        self.tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presenter.deleteAllObservers()
    }
    

    
    func setPresenter(presenter: CalendarPresenter) {
        self.presenter = presenter
    }
    
    
    private func tableViewConfigure() {
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func getDatePickerValue() -> Date {
        return self.datePicker.date
    }
    
    private func deleteSwipeAction(indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, view, completion) in
            self?.presenter.leadingSwipe(row: indexPath.row)
            completion(true)
        }
        deleteAction.image = UIImage(named: "trash.fill")
        deleteAction.backgroundColor = .systemGray
        return deleteAction
    }
    func reloadData() {
        self.tableView.reloadData()
    }
   
}

//MARK: Delegate

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presenter.didTapForCell(row: indexPath.row)
        
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction(indexPath: indexPath)])
    }
}


//MARK: DataSource

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell() }
        cell.titleLabel.text = self.presenter.getTitleForItem(row: indexPath.row)
        cell.timeLable.text = self.presenter.getTimeForItem(row: indexPath.row)
        return cell
    }
}

