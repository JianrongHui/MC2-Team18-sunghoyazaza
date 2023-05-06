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

//MARK: 데이터를 활용해 배열을 만들어
var datesHavingDots : [DateMetaData] = datesForTasks.map { offset in
    DateMetaData(date: getSimpleDate(offset: offset))
}

//MARK: 메인 문구를 위해 연속적인 날이 있는지 확인하는 함수
func findConsecutiveDays()->Int{
    datesForTasks.sort(by: >)
    var index = 0
    var consecutiveDays : Int
    
    if datesForTasks[0] == -1{
        while datesForTasks[index] == datesForTasks[index+1] + 1{
            index += 1
        }
        consecutiveDays = index + 1
    }else{
        consecutiveDays = 0
    }
    
    print(consecutiveDays)
    return consecutiveDays
}
