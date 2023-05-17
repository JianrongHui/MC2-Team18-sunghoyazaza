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
}
