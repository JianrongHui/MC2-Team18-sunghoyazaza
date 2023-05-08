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
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        if activity == .dailySleep {
            // TODO: 샘플로직 수정하기 - 모니터링 시작 시 실드시작
            let managedSettingsStore = ManagedSettingsStore(named: .default)
            managedSettingsStore.shield.applications = selectionToDiscourage.applicationTokens.isEmpty ? nil : selectionToDiscourage.applicationTokens
            managedSettingsStore.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selectionToDiscourage.categoryTokens)
            
        }
        // Handle the start of the interval.
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        // TODO: 샘플로직 수정하기 - 모니터링 끝날 시 스케쥴 초기화
        if activity == .dailySleep {
            // Clear shields
            let managedSettingsStore = ManagedSettingsStore(named: .default)
            managedSettingsStore.clearAllSettings()
        }
        
        // Handle the end of the interval.
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

//MARK: FamilyActivitySelection Parser
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

//MARK: Schedule Name List
extension DeviceActivityName {
    static let dailySleep = Self("dailySleep")
    static let additionalTime = Self("additionalTime")
}

//MARK: Schedule Event Name List
extension DeviceActivityEvent.Name {
    static let `default` = Self("threshold.default")
}
