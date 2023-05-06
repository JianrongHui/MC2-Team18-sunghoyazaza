//
//  DateData.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/07.
//

//MARK: Date를 위한 백 자료들
import SwiftUI


//MARK: Date Struct
struct DateMetaData: Identifiable{
    var id = UUID().uuidString
    var date: Date
}
//MARK: 날짜 가져오기 함수
func getSimpleDate(offset: Int)->Date{
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}


//(Saved Date - Today's Date == offset)
//MARK: 데이터 저장소(현재는 더미), -1, -2는 현재 날짜에서 전날 ,전전날을 의미함
var datesForTasks : [Int] = [
    -1, -2, -3, -4, -8, -9, -10, -11
]

