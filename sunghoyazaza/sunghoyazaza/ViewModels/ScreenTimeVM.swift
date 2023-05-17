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

    // MARK: 제한할 앱 정보를 담고 있는 변수
    @AppStorage(AppStorageKey.selectionToDiscourage.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var selectionToDiscourage = FamilyActivitySelection()
    
    // MARK: 온보딩을 완료한 유저인지 체크하기 위한 변수
    @AppStorage(AppStorageKey.isUserInit.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isUserInitStatus: Bool = true

    // MARK: 스크린 타임 설정 여부
    @AppStorage(AppStorageKey.hasScreenTimePermission.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var hasScreenTimePermission: Bool = false {
        didSet {
            print("Changed: ", hasScreenTimePermission)
            updateHasScreenTimePermission()
        }
    }

    @Published
    var sharedHasScreenTimePermission = false

    func updateHasScreenTimePermission() {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.sharedHasScreenTimePermission = self.hasScreenTimePermission
            }
        }
    }

    // MARK: 스케쥴 시작 시간을 담기 위한 변수
    @AppStorage(AppStorageKey.sleepStartDateComponent.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var sleepStartDateComponent = DateComponents(hour: 23, minute: 00)
    
    // MARK: 스케쥴 종료 시간을 담기 위한 변수
    @AppStorage(AppStorageKey.sleepEndDateComponent.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var sleepEndDateComponent = DateComponents(hour: 07, minute: 00)
    
    // MARK: 사용자 알림 설정 여부
    @AppStorage(AppStorageKey.isUserNotificationOn.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isUserNotificationOn: Bool = true

    // MARK: 오늘 수면 계획 동안 15분 연장 횟수
    @AppStorage(AppStorageKey.additionalCount.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalCount: Int = 0
    
    // MARK: 스케줄 종료 지점 판별을 위한 변수
    @AppStorage(AppStorageKey.isEndPoint.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isEndPoint: Bool = true
    
    // MARK: 추가시간 몇 분 줄지
    @AppStorage(AppStorageKey.additionalMinute.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalMinute: Int = 1
    
    // MARK: 미리 알림 시간 (분)
    @AppStorage(AppStorageKey.warningTime.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var warningTime: Int = 5
    
    let deviceActivityCenter = DeviceActivityCenter()
    let authorizationCenter = AuthorizationCenter.shared

    //MARK: DateComponent 시간값을 00:00 형식의 String으로 변환해주는 계산 프로퍼티
    var sleepStartString: String {
        let userStartAt = self.sleepStartDateComponent
        let startAt = Calendar.current.date(from: userStartAt)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        let timeString = dateFormatter.string(from: startAt)
        
        return timeString
    }
    var sleepEndString: String {
        let userEndAt = self.sleepEndDateComponent
        let endAt = Calendar.current.date(from: userEndAt)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        let timeString = dateFormatter.string(from: endAt)
        
        return timeString
    }
    
    // MARK: 스크린타임 권한 요청
    func requestAuthorization() {
        if authorizationCenter.authorizationStatus == .approved {
            print("ScreenTime Permission approved")
        } else {
            Task {
                do {
                     try await authorizationCenter.requestAuthorization(for: .individual)
                    hasScreenTimePermission = true
                    // 동의함
                 } catch {
                     //동의 X
                     print("Failed to enroll Aniyah with error: \(error)")
                     hasScreenTimePermission = false
                     // 사용자가 허용안함.
                     // Error Domain=FamilyControls.FamilyControlsError Code=5 "(null)
                 }
            }
        }
    }

    // MARK: onReceive 권한 상태 업데이트
    func updateAuthorizationStatus(authStatus: AuthorizationStatus) {
        switch authStatus {
        case .notDetermined:
            hasScreenTimePermission = false
        case .denied:
            hasScreenTimePermission = false
        case .approved:
            hasScreenTimePermission = true
        @unknown default:
            fatalError("요청한 권한설정 타입에 대한 처리는 없습니다")
        }
    }

    // MARK: 모니터링 스케쥴 등록
    func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .dailySleep
    ) {
        //MARK: 기본 수면계획 스케줄일 경우
        if deviceActivityName == .dailySleep {
            handleDailySleepMonitoring(startTime: startTime, endTime: endTime)

        } else { //MARK: 추가시간 15분 스케줄일 경우
            handleAdditionalTimeMonitoring(startTime: startTime, endTime: endTime)
        }
    }
    
    // MARK: 기본 수면계획 스케줄(.dailySleep)일 경우
    func handleDailySleepMonitoring(
        startTime: DateComponents,
        endTime: DateComponents
    ) {
        let schedule = DeviceActivitySchedule(
            intervalStart: startTime,
            intervalEnd: endTime,
            repeats: true,
            warningTime: DateComponents(minute: warningTime) // 미리 알림 시간
        )
        print("Daily Sleep Schedule: \(startTime.hour!):\(startTime.minute!) ~ \(endTime.hour!):\(endTime.minute!)")
        
        do {
            // 모든 액티비티의 모니터링을 중단하고 dailySleep 스케줄만 시작하도록 해줌
            deviceActivityCenter.stopMonitoring()
            try deviceActivityCenter.startMonitoring(
                .dailySleep,
                during: schedule
            )
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    // MARK: 추가시간 사용 이후 스케줄(.additionalTime)일 경우
    func handleAdditionalTimeMonitoring(
        startTime: DateComponents,
        endTime: DateComponents
    ) {
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date()) // 현재시간
        let startHour = currentDateComponents.hour ?? 0
        let startMinute  = currentDateComponents.minute ?? 0
        var endHour = startHour
        // MARK: 추가시간 끝나는 시간 변경하는 부분
        var endMinute = startMinute + additionalMinute // 15분
        if endMinute >= 60 {
            endMinute -= 60
            endHour += 1
        }
        if endHour > 23 {
            endHour = 23
            endMinute = 59
        }
        print("Additional time schedule: \(startHour):\(startMinute) ~ \(endHour):\(endMinute)")
        
        // (추가시간 종료 시점 ~ 수면 종료 시간)의 새로운 스케줄 생성
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: endHour, minute: endMinute),
            intervalEnd: endTime,
            repeats: false,
            warningTime: DateComponents(minute: warningTime) // 스케쥴 시작 및 종료 5분 전에 알림
        )
        
        do {
            // additionalTime 스케줄만 모니터링을 중단한다. (dailySleep는 항상 모니터링 해줘야 하기 때문에)
            deviceActivityCenter.stopMonitoring([.additionalTime])
            try deviceActivityCenter.startMonitoring(
                .additionalTime,
                during: schedule
            )
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

//MARK: ManagedSettingStore Name List
extension ManagedSettingsStore.Name {
    // dailySleep과 additional 각각의 스케줄에 대해 서로 다른 ManagedSettingsStore를 사용하여 dailySleep의 모니터링이 중단되지 않도록 함
    static let dailySleep = Self("dailySleep")
    static let additional = Self("additional")
}
