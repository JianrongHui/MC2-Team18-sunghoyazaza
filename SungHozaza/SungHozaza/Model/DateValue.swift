//
//  DateValue.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/06.
//
//MARK: 날짜 Model

import Foundation
import SwiftUI

struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day : Int
    var date : Date
}
