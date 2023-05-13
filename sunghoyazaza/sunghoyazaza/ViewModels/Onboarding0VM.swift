//
//  Onboarding0VM.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/13.
//

import SwiftUI

struct CarouselItemInfo: Identifiable {
    let id = UUID()
    var idx: Int
    var labelTitle: String
    var labelBody: String
    var src: String
}

//class Onboarding0VM: ObservableObject {
//    @Published
//    var carouselItem = CarouselItemInfo(
//        idx: 0,
//        labelTitle: "⚙️ 수면 계획 설정",
//        labelBody: "⏰ 수면 루틴 : 수면 시간과 요일을 선택해요\n⚠️ 제한할 앱 : 방해가 되는 앱을 선택해요",
//        src: "mustSleep_onboarding_0"
//    )
//
////    init() {
////        carouselItems = [
////    }
////
//    @Published
//    var carouselItems: [CarouselItemInfo]
//}
