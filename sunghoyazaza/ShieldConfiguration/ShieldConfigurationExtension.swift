//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Yun Dongbeom on 2023/05/08.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    // TODO: 커스텀 이미지 추가하기
    let imageName = "stopwatch"
    // TODO: 로직에 따른 문구 분기처리 필요
    let title = ShieldContent.case1.title
    let subtitle = ShieldContent.case1.subTitle
    let primaryButtonnText = ShieldContent.case1.primaryButtonText
    let secondaryButtonText = ShieldContent.case1.secondaryButtonText
    let screenTimeVM = ScreenTimeVM.shared
    let dateModel = DateModel.shared
    let uiColorValue = UIColor(red: 15/255, green: 0/255, blue: 148/255, alpha: 1.0) // Hex 0x0F0094의 UIColor값
    var grade:gradeType{
        
        let totalSuccessCount = dateModel.totalSuccessCount
        let recentSuccessCount = dateModel.recentSuccessCount
        let recentFailCount = dateModel.recentFailCount

        if screenTimeVM.additionalCount == 0{
            if recentSuccessCount == 0{
                if recentFailCount == 0 {
                    return .first
                }else if recentFailCount == 1{
                    return .failOnce
                }else{
                    return .failContinue
                }
            }else if recentSuccessCount == 1{
                if totalSuccessCount == 1{
                    return .firstSuccess
                }else{
                    return .successOnce
                }
            }else{
                return .successContinue
            }
        }else if screenTimeVM.additionalCount == 1{
            return .shieldOnce
        }else{
            return .shieldTwice
        }
    }

    enum gradeType{
        case first
        case failOnce
        case failContinue
        case firstSuccess
        case successOnce
        case successContinue
        case shieldOnce
        case shieldTwice
    }
    var subtitleLabel:String{
        switch grade{
        case .first:
            return """
(N)시간 이상의 수면은
내일의 계획을 지키는 데 필수적이에요

내일의 계획을 지키려면
지금 반드시 잠에 들어야 해요

내일의 계획을 지키기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .failOnce:
            return """
수면 계획 달성 기록이 깨졌지만
힘내서 다시 이어나갈 수 있어요

깨진 기록을 다시 이어나가려면
초심을 되찾고 다시 첫걸음을 내디뎌야 해요

초심을 되찾고 다시 첫걸음을 내딛기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .failContinue:
            return """
\(dateModel.recentFailCount)회째 수면 계획 달성이 안되고 있지만
힘내서 다시 이어나갈 수 있어요

깨진 기록을 다시 이어나가려면
초심을 되찾고 다시 첫걸음을 내디뎌야 해요

초심을 되찾고 다시 첫걸음을 내딛기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .firstSuccess:
            return """
수면 계획을 처음으로 달성한 것
🎉너무너무 잘하셨어요🎉

기록을 계속해서 이어나가면
공무원 시험 합격에 큰 도움이 될 거에요

기록을 계속해서 이어나가기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .successOnce:
            return """
초심을 되찾고 수면 계획을 다시 달성한 것
💪너무너무 잘하셨어요💪

기록을 계속해서 이어나가면
공무원 시험 합격에 큰 도움이 될 거에요

기록을 계속해서 이어나가기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .successContinue:
            return """
\(dateModel.recentSuccessCount)회 연속으로 수면 계획을 달성하고 있는 것
🔥너무너무 잘하고 있어요🔥

기록을 계속해서 이어나가면
공무원 시험 합격에 큰 도움이 될 거에요

기록을 계속해서 이어나가기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .shieldOnce:
            return """
딱 15분만 (앱)을 사용하겠다는
나와의 약속을 지킬 시간이 됐어요

딱 15분만 보겠다는 작은 약속을 잘 지켜야
공무원이 되겠다는 큰 약속도 지킬 수 있겠죠?

나와의 약속을 지키고 내일의 계획도 지키기 위해
이제 그만 (앱)을 종료해볼까요?
"""
        case .shieldTwice:
            return """
내일의 계획을 지키실 수 있도록
저희가 도와드릴 수 있는 것은 여기까지에요

내일의 계획을 지키려면
지금 반드시 잠에 들어야 해요

내일의 계획을 지키기 위해
이제 그만 (앱)을 종료해 주세요
"""
        }
    }
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shiel d as needed for applications.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.extraLight,
            backgroundColor: UIColor.white.withAlphaComponent(0.1),
            icon: UIImage(systemName: imageName),
            title: ShieldConfiguration.Label(text: "titleLabel", color: .black),
            subtitle: ShieldConfiguration.Label(text: subtitleLabel, color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: primaryButtonnText, color: .white),
            primaryButtonBackgroundColor: uiColorValue,
            secondaryButtonLabel: ShieldConfiguration.Label(text: secondaryButtonText, color: uiColorValue)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.extraLight,
            backgroundColor: UIColor.white.withAlphaComponent(0.1),
            icon: UIImage(systemName: imageName),
            title: ShieldConfiguration.Label(text: title, color: .black),
            subtitle: ShieldConfiguration.Label(text: subtitleLabel, color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: primaryButtonnText, color: .white),
            primaryButtonBackgroundColor: uiColorValue,
            secondaryButtonLabel: ShieldConfiguration.Label(text: secondaryButtonText, color: uiColorValue)
        )
    }
    
    // TODO: 미사용 시 제거할지 말지 논의하기
//    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
//        // Customize the shield as needed for web domains.
//        ShieldConfiguration()
//    }
//    
//    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
//        // Customize the shield as needed for web domains shielded because of their category.
//        ShieldConfiguration()
//    }
}
