//
//  Date.swift
//  sunghoyazaza
//
//  Created by jaesik pyeon on 2023/05/11.
//

import Foundation
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    static var now:String{
        let currentDate = Date() // 현재 날짜와 시간을 가져옴
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일을 사용
        dateFormatter.dateFormat = "yyyyMMdd"

        let date = dateFormatter.string(from: currentDate) // 날짜를 문자열로 변환
        return date
    }
    
    //MARK: 현재 월, 일을 알기위한 위한 Extension
    func getAllDates()->[Date] {
        
        let calendar = Calendar.current
        
        // getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

