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
    let title = "😴 잠에 들 시간이에요"
    let subtitle = "\n(N)시간 이상의 숙면은\n내일의 계획을 지키는 데 필수적이에요\n\n내일의 계획을 지키려면\n지금 반드시 잠에 들어야 해요\n\n내일의 계획을 지키기 위해\n이제 그만 앱을 종료해볼까요?"
    let primaryButtonnText = "내일의 계획 지키기"
    let secondaryButtonText = "내일의 계획 안지키기"
    
    let uiColorValue = UIColor(red: 15/255, green: 0/255, blue: 148/255, alpha: 1.0) // Hex 0x0F0094의 UIColor값
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.extraLight,
            backgroundColor: UIColor.white.withAlphaComponent(0.1),
            icon: UIImage(systemName: imageName),
            title: ShieldConfiguration.Label(text: title, color: .black),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .black),
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
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .black),
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
