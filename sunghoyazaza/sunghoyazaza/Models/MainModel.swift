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
    var weekDay : String = "월, 화, 수, 목, 금, 토, 일"
    var sleepTime : String = "11:00PM"
    var wakeupTime : String = "09:00AM"
    
    init() {
        self.weekDay = getWeekDate()
        self.sleepTime = getBedTime()
        self.wakeupTime = getWakeupTime()
    }
    
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

func fDateTime(time: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a hh:mm"
    let timeStirng = dateFormatter.string(from: time)
    
    return timeStirng
}

func getBedTime() -> String {
    let startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Date()
    
    return fDateTime(time: startAt)
}

func getWakeupTime() -> String {
    let endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Date()
    
    return fDateTime(time: endAt)
}

func getWeekDate() -> String {
    let selectedDays:[Bool] = UserDefaults.standard.array(forKey: "selectedDays") as? [Bool] ?? [Bool](repeating: false, count: 7)
    let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    var stringArray:[String] = []
    
    for index in 0 ..< selectedDays.count {
        if (selectedDays[index]) {
            stringArray.append(daysOfWeek[index])
        }
    }
    
    let weekDate = stringArray.joined(separator: ", ")
    return weekDate
}
