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
    
    // 메인 화면 최상단 텍스트 DB
    var mainLabel : [String] = [
        "😿 연속 누적일이\n초기화 되었어요..",
//        "🚀 \(DateVM().findConsecutiveDays())일 연속 6시간 숙면\n진행중!"
    //    "📅 \(findConsecutiveDays())일 연속 8시간 숙면\n루틴을 완성했어요"
    ]

    // 메인 화면 상단 응원 텍스트 DB
    var subLabel : [String] = [
        "오늘부터 다시 시작해볼까요?",
        "오늘 하루도 열심히 공부해요",
        "공무원 합격을 응원합니다. 오늘도 빡공!",
        "7시간 이상의 숙면은 내일의 집중을 도와줍니다."
    ]
    
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


