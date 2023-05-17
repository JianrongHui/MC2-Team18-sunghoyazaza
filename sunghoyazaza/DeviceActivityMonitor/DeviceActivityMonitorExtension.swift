//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by 김영빈 on 2023/05/15.
//

import DeviceActivity
import FamilyControls
import ManagedSettings
import SwiftUI
import Foundation


// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    // MARK: 오늘 수면 계획 동안 15분 연장 횟수
    @AppStorage(AppStorageKey.additionalCount.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalCount: Int!
    // MARK: 스케줄 종료 지점 판별을 위한 변수
    @AppStorage(AppStorageKey.isEndPoint.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isEndPoint: Bool!
    // MARK: 사용자 알림 설정 여부
    @AppStorage(AppStorageKey.isUserNotificationOn.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isUserNotificationOn: Bool = true
    // MARK: 추가시간 몇 분 줄지
    @AppStorage(AppStorageKey.additionalMinute.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalMinute: Int = 1
    // MARK: 미리 알림 시간 (분)
    @AppStorage(AppStorageKey.warningTime.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var warningTime: Int = 5
    
    var selectionToDiscourage = ScreenTimeVM.shared.selectionToDiscourage
    
    // MARK: 스케줄 시작 시점에 호출
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // Handle the start of the interval.
        isEndPoint = true // 현재 스케줄을 종료 지점이라고 봄
        
        if activity == .dailySleep { //MARK: 수면 계획 스케줄 시작
            additionalCount = 0 // 오늘의 스케줄의 additionalCount값 0으로 초기화
            // .dailySleep 쉴드 ON
            let dailySleepStore = ManagedSettingsStore(named: .dailySleep)
            dailySleepStore.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
            dailySleepStore.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
            
        } else if activity == .additionalTime { //MARK: 15분 추가시간 이후 스케줄 시작
            // .additional 쉴드 ON
            let additionalStore = ManagedSettingsStore(named: .additional)
            additionalStore.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
            additionalStore.shield.applicationCategories = selectionToDiscourage.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
            
        }
    }
    
    // MARK: 스케줄 종료 시점 or 모니터링 중단 시 호출
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // 해당 스케줄의 ManagedSettingsStore 초기화 (쉴드 해제)
        if activity == .dailySleep {
            let dailySleepStore = ManagedSettingsStore(named: .dailySleep)
            dailySleepStore.clearAllSettings()
        } else if activity == .additionalTime {
            let additionalStore = ManagedSettingsStore(named: .additional)
            additionalStore.clearAllSettings()
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    //MARK: 스케줄 시작 전 설정한 시간 (warningTime)에 미리 알림
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        // Handle the warning before the interval starts.
        //MARK: 사용자가 알림을 켜놨으면 동작
        if isUserNotificationOn {
            if activity == .dailySleep { //MARK: 수면 스케줄 시작 알림
                NotificationManager.shared.requestNotificationCreate(
                    title: "수면 계획이 곧 시작됩니다.",
                    subtitle: "\(warningTime)분 뒤에 설정한 수면 계획 시작"
                )
            } else if activity == .additionalTime {
                if additionalCount < 2 { //MARK: 1회째 연장 이후 수면 스케줄 시작 알림
                    NotificationManager.shared.requestNotificationCreate(
                        title: "약속한 시간이 다가옵니다.",
                        subtitle: "\(additionalMinute)분 뒤에 설정한 수면 계획 시작"
                    )
                } else { //MARK: 2회째 연장 이후 수면 스케줄 시작 알림
                    NotificationManager.shared.requestNotificationCreate(
                        title: "최후의 약속이 끝나갑니다.",
                        subtitle: "\(additionalMinute)분 뒤에 설정한 수면 계획 다시 시작"
                    )
                }
            }
        }
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
