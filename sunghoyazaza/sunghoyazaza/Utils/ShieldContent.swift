//
//  ShieldContent.swift
//  sunghoyazaza
//
//  Created by 김영빈 on 2023/05/11.
//

import Foundation

//MARK: 쉴드 화면 컨텐츠
enum ShieldContent {
    case case1 //MARK: [1] 쉴드 0회, 기록X, 최초
    case case2 //MARK: [2] 쉴드 0회, 기록X, 최초X, 1회연장
    case case3 //MARK: [3] 쉴드 0회, 기록X, 최초X, N회연장
    case case4 //MARK: [4] 쉴드 0회, 기록O, 1회 성공, 최초
    case case5 //MARK: [5] 쉴드 0회, 기록O, 1회 성공, 최초X
    case case6 //MARK: [6] 쉴드 0회, 기록O, 2회 이상 성공
    case case7 //MARK: [7] 쉴드 1회
    case case8 //MARK: [8] 쉴드 2회

    var title: String {
        switch self {
        case .case1, .case2, .case3, .case4, .case5, .case6:
            return "😴 잠에 들 시간이에요"
        case .case7:
            return "⌛️ 약속한 시간이 됐어요"
        case .case8:
            return "🙏 이제 제발 잠에 드세요"
        }
    }

    //MARK: 총 수면 시간 계산
    var totalSleepTime: Int {
        let sleepHours = ScreenTimeVM.shared.sleepEndDateComponent.hour! - ScreenTimeVM.shared.sleepStartDateComponent.hour!
        return sleepHours >= 0 ? sleepHours : 24 + sleepHours
    }
    
    var subTitle: String {
        switch self {
        case .case1:
            return "\n\(self.totalSleepTime)시간 이상의 숙면은\n내일의 계획을 지키는 데 필수적이에요\n\n내일의 계획을 지키려면\n지금 반드시 잠에 들어야 해요\n\n내일의 계획을 지키기 위해\n이제 그만 앱을 종료해볼까요?"
        case .case2:
            return "\n수면 계획 달성 기록이 깨졌지만\n힘내서 다시 이어나갈 수 있어요\n\n깨진 기록을 다시 이어나가려면\n초심을 되찾고 다시 첫걸음을 내디뎌야 해요\n\n초심을 되찾고 다시 첫걸음을 내딛기 위해\n이제 그만 (앱)을 종료해볼까요?"
        case .case3:
            return "\n\(DateModel.shared.recentFailCount)회째 수면 계획 달성이 안되고 있지만\n힘내서 다시 이어나갈 수 있어요\n\n깨진 기록을 다시 이어나가려면\n초심을 되찾고 다시 첫걸음을 내디뎌야 해요\n\n초심을 되찾고 다시 첫걸음을 내딛기 위해\n이제 그만 (앱)을 종료해볼까요?"
        case .case4:
            return "\n수면 계획을 처음으로 달성한 것\n🎉너무너무 잘하셨어요🎉\n\n기록을 계속해서 이어나가면\n공무원 시험 합격에 큰 도움이 될 거에요\n\n기록을 계속해서 이어나가기 위해\n이제 그만 앱을 종료해볼까요?"
        case .case5:
            return "\n초심을 되찾고 수면 계획을 다시 달성한 것\n💪너무너무 잘하셨어요💪\n\n기록을 계속해서 이어나가면\n공무원 시험 합격에 큰 도움이 될 거에요\n\n기록을 계속해서 이어나가기 위해\n이제 그만 앱을 종료해볼까요?"
        case .case6:
            return "\n\(DateModel.shared.recentSuccessCount)회 연속으로 수면 계획을 달성하고 있는 것\n🔥너무너무 잘하고 있어요🔥\n\n기록을 계속해서 이어나가면\n공무원 시험 합격에 큰 도움이 될 거에요\n\n기록을 계속해서 이어나가기 위해\n이제 그만 (앱)을 종료해볼까요?"
        case .case7:
            return "\n딱 15분만 앱을 사용하겠다는\n나와의 약속을 지킬 시간이 됐어요\n\n딱 15분만 보겠다는 작은 약속을 잘 지켜야\n공무원이 되겠다는 큰 약속도 지킬 수 있겠죠?\n\n나와의 약속을 지키고 내일의 계획도 지키기 위해\n이제 그만 앱을 종료해볼까요?"
        case .case8:
            return "\n내일의 계획을 지키실 수 있도록\n저희가 도와드릴 수 있는 것은 여기까지에요\n\n내일의 계획을 지키려면\n지금 반드시 잠에 들어야 해요\n\n내일의 계획을 지키기 위해\n이제 그만 앱을 종료해 주세요"
        }
    }

    var primaryButtonText: String {
        switch self {
        case .case1: return "내일의 계획 지키기"
        case .case2, .case3:
            return "초심 되찾기"
        case .case4, .case5, .case6:
            return "기록 이어나가기"
        case .case7:
            return "나와의 약속 지키기"
        case .case8:
            return "종료하기"
        }
    }

    var secondaryButtonText: String {
        switch self {
        case .case1:
            return "내일의 계획 안지키기"
        case .case2, .case3:
            return "초심 버리기"
        case .case4, .case5, .case6:
            return "기록 깨뜨리기"
        case .case7:
            return "나와의 약속 어기기"
        case .case8:
            return "" // secondaryButtonText 없음
        }
    }
}

