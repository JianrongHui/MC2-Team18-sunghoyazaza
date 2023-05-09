//
//  sunghoyazazaApp.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/07.
//

import SwiftUI

@main
struct sunghoyazazaApp: App {
    // TODO::앱 시작 시 Permission State 확인하기
    let hasPermission = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if hasPermission {
                    MainView()
                }
                else {
                    StartPermissionView()
                }
            }
        }
    }
}
