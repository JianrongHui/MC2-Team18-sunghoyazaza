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
