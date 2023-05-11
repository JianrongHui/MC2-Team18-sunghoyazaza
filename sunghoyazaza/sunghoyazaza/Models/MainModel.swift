//
//  MainTextData.swift
//  sunghoyazaza
//
//  Created by 077tech on 2023/05/07.
//
import Foundation
import SwiftUI

//MARK: 메인 뷰 DB

struct MainModel{
    
    let dateModel = DateModel.shared
    // 메인 화면 최상단 텍스트 DB
    var mainLabel:String{
        switch dateModel.grade{
        case .noRecord:
            return "noRecord"
        case .successContinue:
            return "successContinue - \(dateModel.recentSuccessCount)"
        case .firstSuccess:
            return "firstSuccess"
        case .onlyFail:
            return "onlyFail"
        case .failAfterSuccess:
            return "failAfterSuccess"
        case .failContinueAfterSuccess:
            return "failContinueAfterSuccess - \(dateModel.recentFailCount)"
        case .successFailSuccess:
            return "successFailSuccess"
        @unknown default:
            return "another"
            
        }
    }

    // 메인 화면 상단 응원 텍스트 DB
    var subLabel:String{
        switch dateModel.grade{
        case .noRecord:
            return "noRecord"
        case .successContinue:
            return "successContinue"
        case .firstSuccess:
            return "firstSuccess"
        case .onlyFail:
            return "onlyFail"
        case .failAfterSuccess:
            return "failAfterSuccess"
        case .failContinueAfterSuccess:
            return "failContinueAfterSuccess"
        case .successFailSuccess:
            return "case successFailSuccess"
        @unknown default:
            return "another"
            
        }
    }
    
    //MARK: 달력 DB는 따로 정리 ==> DateModel()
    //MARK: 달력 DB는 따로 정리 ==> DateModel()
    //MARK: 달력 DB는 따로 정리 ==> DateModel()
    
    
    // 수면 계획 "취침시간 + 기상시간 + 해당요일" DB
    @State var weekDay : String = "월, 화, 수, 목, 금, 토, 일"
    @State var sleepTime : String = "11:00PM"
    @State var wakeupTime : String = "09:00AM"
    
    // 차단된 어플리케이션 목록 DB
    var blockApplicationData: [String] = [
        "instagram",
        "youtube",
        "toss",
        "kakaotalk",
        "line",
        "discord",
        "facebook",
        "tiktok",
        "facebook",
        "tiktok",
        "facebook",
        "tiktok",
        "facebook",
        "tiktok"
    ]
    


}


