//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 정유진 on 2022/07/04.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    var covidOverview: CovidOverview?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName
        self.newCaseCell.detailTextLabel?.text = "\(intToString(intToString: covidOverview.newCase))명"
        self.totalCaseCell.detailTextLabel?.text = "\(intToString(intToString: covidOverview.totalCase))명"
        self.recoveredCell.detailTextLabel?.text = "\(intToString(intToString: covidOverview.recovered))명"
        self.deathCell.detailTextLabel?.text = "\(intToString(intToString: covidOverview.death))명"
        self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)%"
        self.overseasInflowCell.detailTextLabel?.text = "\(intToString(intToString: covidOverview.newFcase))명"
        self.regionalOutbreakCell.detailTextLabel?.text = "\(intToString(intToString: covidOverview.newCcase))명"
    }
    
    func intToString(intToString: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: intToString)) ?? "0"
    }
}
