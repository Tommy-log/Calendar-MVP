//
//  DescriptionViewController .swift
//  Calendar
//
//  Created by Admin on 06.02.2021.
//

import UIKit

protocol DescriptionViewProtocol {
    
}

class DescriptionViewController: UIViewController, DescriptionViewProtocol {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var presenter: DescriptionPresenterProtocol!
    var transmittedTitle: String?
    var transmittedDescription: String?
    var transmittedDate: String?
    var transmittedTime: String?
    
    override func viewDidLoad() {
        self.titleLabel.text = transmittedTitle
        self.descriptionLabel.text = transmittedDescription
        self.dateLabel.text = transmittedDate
        self.timeLabel.text = transmittedTime
    }
    
    func setPresenter(presenter: DescriptionPresenterProtocol) {
        self.presenter = presenter
    }
    
}
