//
//  DateVM.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/07.
//

import Foundation

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
    
    return consecutiveDays
}

//MARK: 메인 문구 바꿔주기
func changeMainText()->Int{
    var indexNumber : Int
    
    if findConsecutiveDays() == 0{
        indexNumber = 0
    } else{
        indexNumber = 1
    }
    return indexNumber
}
