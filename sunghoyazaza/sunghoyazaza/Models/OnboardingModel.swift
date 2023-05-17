//
//  onboardingModel.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/17.
//

import Foundation

struct CarouselItemInfo: Identifiable {
    let id = UUID()
    var idx: Int
    var labelTitle: String
    var labelBody: String
    var src: String
}

struct PermissionButtonInfo: Identifiable {
    let id = UUID()
    let headerText: String
    let src: String
    let permissionName: String
    let footerText: String
}
