//
//  ViewController.swift
//  COVID19
//
//  Created by 정유진 on 2022/07/03.
//

import UIKit
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    //차트 라이브러리 안에 포함되어 import Charts를 작성
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

