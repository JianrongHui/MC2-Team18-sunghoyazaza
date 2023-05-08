//
//  NotificationManager.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/08.
//

import Foundation
import UserNotifications



class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    //MARK: 알림 권한요청
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {(success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    // TODO: 노티피케이션 요청방식 논의필요, 현재는 시간을 기준으로 작성
    // MARK: 노티피케이션 생성 및 요청
    func requestNotificationCreate(
        title: String = "Sample Notification Title",
        subtitle: String = "Sample Notification SubTitle",
        timeInterval: Double = 5.0
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
}
