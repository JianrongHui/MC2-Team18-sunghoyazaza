//
//  DateData.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/07.
//

//MARK: Date를 위한 백 자료들
import SwiftUI

struct DateModel{
    
    //(Saved Date - Today's Date == offset)
    //MARK: 데이터 저장소(현재는 더미), -1, -2는 현재 날짜에서 전날 ,전전날을 의미함
    var datesForTasks : [Int] = [
        -1, -2, -3, -4, -8, -9, -10, -11
    ]
    
    //MARK: 캘린더 상단 요일 데이터
    let upperDays : [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
}
