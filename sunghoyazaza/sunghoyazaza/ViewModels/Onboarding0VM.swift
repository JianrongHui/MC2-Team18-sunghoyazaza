//
//  Onboarding0VM.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/13.
//

import SwiftUI

class Onboarding0VM: ObservableObject {
    
    init() {
        self.carouselItems = [
            /// 0
            CarouselItemInfo(
                idx: 0,
                labelTitle: "머스트 슬립과 함께\n자야 할 시간에 잠에 들고\n내일의 계획을 지켜 보세요",
                labelBody: "",
                src: "mustSleep_onboarding_0"
            ),
            /// 1
            CarouselItemInfo(
                idx: 1,
                labelTitle: "⚙️ 수면 계획 설정",
                labelBody: "⏰ 수면 루틴 : 수면 시간과 요일을 선택해요\n⚠️ 제한할 앱 : 방해가 되는 앱을 선택해요",
                src: "mustSleep_onboarding_1"
            ),
            /// 2
            CarouselItemInfo(
                idx: 2,
                labelTitle: "😴 수면 계획 실행",
                labelBody: "수면 루틴’에 해당하는 시간이 되면\n‘제한할 앱’에 해당하는 앱이 제한돼요",
                src: "mustSleep_onboarding_2"
            ),
            /// 3
            CarouselItemInfo(
                idx: 3,
                labelTitle: "🔥 연속 달성 기록 확인",
                labelBody: "몇 회 연속으로 자야 할 시간에 잠에 들었는지,\n현재 달성 중인 기록을 확인할 수 있어요",
                src: "mustSleep_onboarding_3"
            ),
            /// 4
            CarouselItemInfo(
                idx: 4,
                labelTitle: "⏳ 딱 15분만!",
                labelBody: "제한된 앱의 사용을 참는게 너무나도 힘들면\n우리, 딱 15분만 사용하기로 약속해요\n단, 현재 달성 중인 기록은 깨지게 돼요",
                src: "mustSleep_onboarding_4"
            ),
            /// 5
            CarouselItemInfo(
                idx: 5,
                labelTitle: "머스트 슬립이\n자야 할 시간에 잠에 들도록 도와드리려면\n몇 가지 기능에 대한 권한 설정이 필요해요\n권한을 설정하고 내일의 계획을 지켜보세요",
                labelBody: "",
                src: "mustSleep_onboarding_5"
            )
        ]
    }

    @Published
    var carouselItems: [CarouselItemInfo]
}
