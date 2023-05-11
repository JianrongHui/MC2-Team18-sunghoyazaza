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
            
        } else if activity == .additionalTime { // 추가 15분 스케줄 종료
            let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
            managedSettingsStore.clearAllSettings()
            
        }
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        // Handle the warning before the interval starts.
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
