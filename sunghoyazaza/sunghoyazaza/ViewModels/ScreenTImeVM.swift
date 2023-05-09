//
//  ScreenTImeVM.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/08.
//
import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import SwiftUI

// MARK: ScreenTime과 관련된 데이터를 관리하기 위한 Class
class ScreenTimeVM: ObservableObject {
    static let shared = ScreenTimeVM()
    private init() {}
    
    @AppStorage(AppStorageKey.selectionToDiscourage.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var selectionToDiscourage = FamilyActivitySelection()

    // MARK: 스케쥴 시작 시간을 담기 위한 변수
    @AppStorage(AppStorageKey.sleepStartDateComponent.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var sleepStartDateComponent = DateComponents()
    
    // MARK: 스케쥴 종료 시간을 담기 위한 변수
    @AppStorage(AppStorageKey.sleepEndDateComponent.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var sleepEndDateComponent = DateComponents()
    
    // MARK: 사용자 알림 설정 여부
    @AppStorage(AppStorageKey.isUserNotificationOn.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isUserNotificationOn: Bool = true
    
    let managedSettingStore = ManagedSettingsStore()
    let deviceActivityCenter = DeviceActivityCenter()
    
    // MARK: 스크린타임 권한 요청
    func requestAuthorization() {
        let center = AuthorizationCenter.shared
        
        if center.authorizationStatus == .approved {
            print("ScreenTime Permission approved")
        } else {
            Task {
                do {
                     try await center.requestAuthorization(for: .individual)
                    // 동의함
                 } catch {
                     //동의 X
                     print("Failed to enroll Aniyah with error: \(error)")
                     // 사용자가 허용안함.
                     // Error Domain=FamilyControls.FamilyControlsError Code=5 "(null)
                 }
            }
        }
    }
    
    // MARK: 스크린타임 권한 조회
    func requestAuthorizationStatus() -> AuthorizationStatus {
        AuthorizationCenter.shared.authorizationStatus
    }
    
    // MARK: 선택했던 토큰 정보 초기화
    func handleResetSelection() {
        selectionToDiscourage = FamilyActivitySelection()
    }
    
    // MARK: 모니터링 스케쥴 등록
    func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents = DateComponents(hour: 23, minute: 59),
        deviceActivityName: DeviceActivityName = .dailySleep,
        warningTime: DateComponents = DateComponents(minute: 1)
    ) {
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: true,
            warningTime: warningTime
        )
        
        let event = DeviceActivityEvent(
            applications: selectionToDiscourage.applicationTokens,
            categories: selectionToDiscourage.categoryTokens,
            webDomains: selectionToDiscourage.webDomainTokens,
            threshold: DateComponents(minute: 1) // 테스트 필요 시 수정해서 사용할 것 ex) minute: 15
        )
        
        do {
            ScreenTimeVM.shared.deviceActivityCenter.stopMonitoring()
            try ScreenTimeVM.shared.deviceActivityCenter.startMonitoring(
                deviceActivityName,
                during: schedule,
                events: [.default: event]
            )
            print("Monitoring started")
        } catch {
            print("Unexpected error: \(error).")
        }
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

extension DateComponents: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(DateComponents.self, from: data)
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
