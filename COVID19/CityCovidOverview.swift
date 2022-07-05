//
//  CityCovidOverview.swift
//  COVID19
//
//  Created by 정유진 on 2022/07/05.
//

import Foundation

struct CityCovidOverview: Codable {
    let korea: CovidOverview
    let seoul: CovidOverview
    let busan: CovidOverview
    let daegu: CovidOverview
    let incheon: CovidOverview
    let daejeon: CovidOverview
    let ulsan: CovidOverview
    let sejong: CovidOverview
    let gyeonggi: CovidOverview
    let gangwon: CovidOverview
    let chungbuk: CovidOverview
    let chungnam: CovidOverview
    let jeonbuk: CovidOverview
    let jeonnam: CovidOverview
    let gyeongbuk: CovidOverview
    let gyeongnam: CovidOverview
    let jeju: CovidOverview
}


struct CovidOverview: Codable {
    let countryName: String
    let newCase: Int
    let totalCase: Int
    let recovered: Int
    let death: Int
    let percentage: Int
    let newCcase: Int
    let newFcase: Int
    
    enum CodingKeys: String, CodingKey {
        case countryName = "countryNm" //데이터에 해당하는 시도명
        case newCase = "incDec" //전일대비 확진자 수
        case totalCase = "totalCnt" //코로나19 확진자 수(전체)
        case recovered = "recCnt"   //코로나19 완치자 수
        case death = "deathCnt"    //코로나19 사망자 수
        case percentage = "qurRate" //코로나19 발생률
        case newCcase = "incDecK"   //전일대비(지역)
        case newFcase = "incDecF"   //전일대비(해외)
    }
}

