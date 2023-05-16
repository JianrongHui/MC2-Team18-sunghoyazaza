//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by 김영빈 on 2023/05/15.
//

import DeviceActivity
import Foundation
import ManagedSettings
import SwiftUI

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    // MARK: 오늘 수면 계획 동안 15분 연장 횟수
    @AppStorage(AppStorageKey.additionalCount.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var additionalCount: Int = 0
    
    // MARK: 스케줄 종료 지점 판별을 위한 변수
    @AppStorage(AppStorageKey.isEndPoint.rawValue, store: UserDefaults(suiteName: APP_GROUP_NAME))
    var isEndPoint: Bool = true
        
    //MARK: application으로 선택된 앱에서의 동작
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            handleAdditionalTimeAction()
            completionHandler(.none)
        @unknown default:
            fatalError()
        }
    }
    
    //MARK: category로 선택된 앱에서의 동작
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            handleAdditionalTimeAction()
            completionHandler(.none)
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: 두번째 버튼 클릭 시 추가 시간 주는 로직
    private func handleAdditionalTimeAction() {
        registAdditionalSchedule()
        updateDateModel()
    }
    
    //MARK: 15분 연장 스케줄 모니터링 시작
    private func registAdditionalSchedule() {
        isEndPoint = false // 종료 지점을 다음 스케줄로 넘김
        additionalCount += 1 // 연장 횟수 1 카운트
        ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
            startTime: ScreenTimeVM.shared.sleepStartDateComponent,
            endTime: ScreenTimeVM.shared.sleepEndDateComponent,
            deviceActivityName: .additionalTime
        )
    }
    
    //MARK: 실패일 데이터 갱신
    private func updateDateModel() {
        //실패 데이터(yyyymmdd)를 DateModel의 failList에 append
        var current = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: current)
        
        if hour < 12{
            current = calendar.date(byAdding: .day, value: -1, to: current)!
        }
        
        let dateString = current.toString()
        if var failList = DateModel.shared.failList.decode, !failList.contains(dateString){
            failList.append(dateString)
            DateModel.shared.failList = (failList.encode)!
            
        }
    }
}
