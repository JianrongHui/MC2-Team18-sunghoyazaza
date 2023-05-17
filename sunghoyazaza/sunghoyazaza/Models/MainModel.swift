//
//  MainTextData.swift
//  sunghoyazaza
//
//  Created by 077tech on 2023/05/07.
//
import Foundation
import SwiftUI

//MARK: 메인 뷰 DB

class MainModel:ObservableObject{
    
    var dateModel = DateModel.shared
    // 메인 화면 최상단 텍스트 DB
    var mainLabel:String{
        switch dateModel.grade{
        case .noRecord:
            return "수면 계획을 달성하고\n첫걸음을 내디뎌요 👣"
        case .successContinue:
            return "\(dateModel.recentSuccessCount)일 연속으로\n수면 계획을 달성했어요 🔥"
        case .firstSuccess:
            return "수면 계획을\n처음으로 달성했어요 🎉"
        case .onlyFail:
            return "수면 계획을 달성하고\n첫걸음을 내디뎌요 👣"
        case .failAfterSuccess:
            return "기록이 깨졌지만\n힘내서 다시 시작해요 💪"
        case .failContinueAfterSuccess:
            return "수면 계획 달성이\n\(dateModel.recentFailCount)일째 안되고 있어요 🥺"
        case .successFailSuccess:
            return "초심을 찾으셨군요\n오늘부터 다시 달려요 🏃"
        @unknown default:
            return "another"            
        }
    }
    let subLabelList:[String] = [
        "미국 국립 수면 재단은 7-9시간의 수면을 권장해요",
        "숙면의 핵심은 매일 일정한 시간에 일어나는 것이에요",
        "합격생의 90%가 규칙적인 수면 시간을 강조했어요",
        "7시간 이상의 숙면은 내일 집중할 수 있게 도와줘요",
        "오늘 하루도 열심히 공부해요",
        "항상 당신을 응원하고 있어요",
        "노력한 만큼의 결과가 있기를 기원해요",
        "힘들겠지만 조금만 참고 버티면 좋은 결과 있을거에요",
        "공무원이 된 나의 모습을 상상해봐요",
        "공무원이 된 나의 모습이 기대되지 않나요?"
    ]
    // 메인 화면 상단 응원 텍스트 DB
    var subLabel:String{
        subLabelList[Int(arc4random_uniform(UInt32(Int32(subLabelList.count))))]
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
    //let startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Date()
    //MARK: 사용자 설정 시간값 불러오기 (DateComponenet -> Date 타입 변환)
    let userStartAt = ScreenTimeVM.shared.sleepStartDateComponent
    let startAt = Calendar.current.date(from: userStartAt)!
    
    return fDateTime(time: startAt)
}

func getWakeupTime() -> String {
    //let endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Date()
    //MARK: 사용자 설정 시간값 불러오기 (DateComponenet -> Date 타입 변환)
    let userEndAt = ScreenTimeVM.shared.sleepEndDateComponent
    let endAt = Calendar.current.date(from: userEndAt)!
    
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
