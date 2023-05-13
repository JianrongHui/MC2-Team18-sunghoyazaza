//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by Yun Dongbeom on 2023/05/08.
//

import DeviceActivity
import FamilyControls
import ManagedSettings
import SwiftUI


// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    @AppStorage(AppStorageKey.selectionToDiscourage.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var selectionToDiscourage = FamilyActivitySelection()
    
    //MARK: 스케줄 시작 시점에 호출
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        // Handle the start of the interval.
        if activity == .dailySleep { // 수면 계획 스케줄 시작
            let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
            managedSettingsStore.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
            managedSettingsStore.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
            
        } else if activity == .additionalTime { // 추가 15분 스케줄 시작
            let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
            managedSettingsStore.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
            managedSettingsStore.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
            
        }
    }
    
    //MARK: 스케줄 종료 시점 or 모니터링 중단 시 호출
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // Handle the end of the interval.
        if activity == .dailySleep { // 수면 계획 스케줄 종료
            let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
            managedSettingsStore.clearAllSettings()
            ScreenTimeVM.shared.additionalCount = 0 // 스케줄 연장 횟수 카운트 초기화
            
        } else if activity == .additionalTime { // 추가 15분 스케줄 종료
            let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
            managedSettingsStore.clearAllSettings()
            ScreenTimeVM.shared.additionalCount = 0
            
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
        if activity == .dailySleep { //MARK: 수면 스케줄 시작 알림
            NotificationManager.shared.requestNotificationCreate(
                title: "수면 계획이 곧 시작됩니다.",
                subtitle: "5분 뒤에 설정한 수면 계획 시작"
            )
        } else if activity == .additionalTime {
            if ScreenTimeVM.shared.additionalCount < 2 { //MARK: 1회째 연장 이후 수면 스케줄 시작 알림
                NotificationManager.shared.requestNotificationCreate(
                    title: "약속한 시간이 다가옵니다.",
                    subtitle: "5분 뒤에 설정한 수면 계획 시작"
                )
            } else { //MARK: 2회째 연장 이후 수면 스케줄 시작 알림
                NotificationManager.shared.requestNotificationCreate(
                    title: "최후의 약속이 끝나갑니다.",
                    subtitle: "5분 뒤에 설정한 수면 계획 다시 시작"
                )
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
