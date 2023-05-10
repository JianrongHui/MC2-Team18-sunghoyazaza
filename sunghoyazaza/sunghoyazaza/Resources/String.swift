//
//  String.swift
//  sunghoyazaza
//
//  Created by jaesik pyeon on 2023/05/11.
//

import Foundation
extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
