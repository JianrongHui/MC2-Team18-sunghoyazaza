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
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
            backgroundColor: UIColor.white,
            icon: UIImage(systemName: imageName),
            title: ShieldConfiguration.Label(text: "No app for you", color: .yellow),
            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .black),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .black)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemThickMaterial,
            backgroundColor: UIColor.white,
            icon: UIImage(systemName: imageName),
            title: ShieldConfiguration.Label(text: "No app for you", color: .yellow),
            subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .black),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Quick Quick", color: .black)
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
