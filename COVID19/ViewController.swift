//
//  ViewController.swift
//  COVID19
//
//  Created by 정유진 on 2022/07/03.
//

import UIKit

import Alamofire
import Charts

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    //차트 라이브러리 안에 포함되어 import Charts를 작성
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview(completionHandler: { [weak self] /*순환참조방지*/ result in
            guard let self = self else { return } //일시적으로 self가 strong 래퍼런스가 되게
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                //Alamofire에서 completionHandler는 메인쓰레드에서 동작하여 따로 메인 디스패치큐를 안만들어도 된다
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChatView(covidOverviewList: covidOverviewList)
            case let .failure(result):
                debugPrint("error \(result)")
            }
        })
    }
    
    func makeCovidOverviewList(
        cityCovidOverview: CityCovidOverview
    ) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    func configureChatView(covidOverviewList: [CovidOverview]) {
        //파이차트에 데이터를 표시하려면 파이차트 데이터 엔트리 객체에 데이터를 추가해야함
        //[CovidOverview]로 받은 데이터를 pieChart엔트리 객체로 mapping 하기
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(string: String(overview.newCase)),
                label: overview.countryName,
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1 //항목별 간격
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        dataSet.colors = ChartColorTemplates.vordiplom() +
            ChartColorTemplates.joyful() +
            ChartColorTemplates.liberty() +
            ChartColorTemplates.pastel() +
            ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        //그래프 회전 시키기
        self.pieChartView.spin(
            duration: 0.3,
            fromAngle: self.pieChartView.rotationAngle,
            toAngle: self.pieChartView.rotationAngle + 80
        )
    }
    
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0 //잘 동작하는지 확인 필요 **
    }
    
    func intToString(intToString: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: intToString)) ?? "0"
    }
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text = "\(intToString(intToString: koreaCovidOverview.totalCase))명"
        self.newCaseLabel.text = "\(intToString(intToString: koreaCovidOverview.newCase))명"
    }

    func fetchCovidOverview(
        /*이스케이핑 클로저로 선언
         completionHandler: (Result<CityCovidOverview, Error>) -> Void
         이스케이핑 클로저는 클로저가 함수로 이스캐이프 즉 탈출 한다는 것
         함수의 인자로 클로저가 전달 되지만 함수가 반환된 후에도 실행 되는 것
         */
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
        /*api를 요청하고 서버에서 json데이터를 응답받거나 요청이 실패하였을 때
          comletionHandler 클로저를 호출해 해당 클로저를 정의하는 곳에 응답 받은 데이터를 전달하려고 한다
        Result<> 첫 제널, 요청이 성공하면 CityCovidOverview 값을 전달 받을 수 있게
         두번째 제널, 요청에 실패하거나 에러상황
         */
    ) {
        let url = "https://api.corona-19.kr/korea/beta/"
        //딕셔너리타입으로 대입
        let param = [
            "serviceKey": "FDqm5ILHcZa6MKvkQbAlUyTzhOGfsBnwX"
        ]
        //호출하기
        AF.request(url, method: .get, parameters: param)
        //호출 하였으면 응답 데이터를 받을 수 있는 메서드를 체이닝
            .response(completionHandler: { response in
                /*completionHandler클로저를 정의하면 응답데이터가
                 클로저 파라미터로 전달되게 된다
                 */
                
                //요청에 대한 응답 결과를 알 수 있다 (response.result << 열거형이다)
                switch response.result {
                case let .success(data):
                    //요철 결과가 성공이면 연관값으로 서버에서 응답받은 데이터가 전달 됨
                    //json 데이터를 CityCovidOverview에 맵핑되도록 한다
                    do {
                        let decoder = JSONDecoder()
                        guard let data = data else { return } //.success() Data가 옵셔널로 바뀌었다
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        //fetchCovidOverview에 정의한 completionHandler클로저 호출
                        completionHandler(.success(result))
                    } catch {
                        //맵핑에 실패한다면
                        completionHandler(.failure(error))
                    }
                case let .failure(Error):
                    //요청이 실패하였을 때
                    completionHandler(.failure(Error))
                }
            })
    }

}

