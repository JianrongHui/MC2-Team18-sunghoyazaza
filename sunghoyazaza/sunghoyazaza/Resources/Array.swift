//
//  Array.swift
//  sunghoyazaza
//
//  Created by jaesik pyeon on 2023/05/14.
//

import Foundation
extension Array where Element == String {
    var encode:String?{
        do {
            let encodedData = try JSONEncoder().encode(StringArray(strings: self))
            let encodedString = String(data: encodedData, encoding: .utf8)
            return encodedString
        } catch {
            return nil
        }
    }
}
