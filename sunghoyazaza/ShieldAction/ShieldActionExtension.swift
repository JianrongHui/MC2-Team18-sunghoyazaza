//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by Yun Dongbeom on 2023/05/08.
//

import DeviceActivity
import Foundation
import ManagedSettings

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    let managedSettingsStore = ManagedSettingsStore(named: .default)
    
    //MARK: application으로 선택된 앱에서의 동작
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            // 기존 수면시간 스케줄의 모니터링 중단
            ScreenTimeVM.shared.deviceActivityCenter.stopMonitoring([.dailySleep])
            // 15분 연장 스케줄 모니터링 시작
            ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
                startTime: DateComponents(hour: 23, minute: 00), //TODO: 어떤 값을 넣어줘도 상관 X (적절하게 코드 수정)
                endTime: DateComponents(hour: 07, minute: 00) //TODO: 사용자 설정 종료 시간으로 수정 필요
            )
            completionHandler(.none)
        @unknown default:
            fatalError()
        }
    }
    
    // TODO: 미사용 시 제거할지 말지 논의하기
//    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
//        // Handle the action as needed.
//        completionHandler(.close)
//    }
    
    //MARK: category로 선택된 앱에서의 동작
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            //TODO: 오늘의 약속 지키기 실패 시 실패 날짜 리스트에 해당 스케줄 날짜 추가
            //dummyDate.append(DateValue.key)
            // 기존 수면시간 스케줄의 모니터링 중단
            ScreenTimeVM.shared.deviceActivityCenter.stopMonitoring([.dailySleep])
            // 15분 연장 스케줄 모니터링 시작
            ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
                startTime: ScreenTimeVM.shared.sleepStartDateComponent, // 어떤 값을 넣어줘도 상관 X
                endTime: ScreenTimeVM.shared.sleepEndDateComponent, // 사용자 설정 종료 시간
                deviceActivityName: .additionalTime
            )
            completionHandler(.none)
            
        @unknown default:
            fatalError()
        }
    }
}

//TODO: 이벤트 미사용 - 논의 후 코드 삭제
//extension DeviceActivityEvent.Name {
//    static let `default` = Self("threshold.default")
//}
