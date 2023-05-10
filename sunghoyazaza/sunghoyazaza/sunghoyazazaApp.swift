//
//  sunghoyazazaApp.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/07.
//

import SwiftUI

@main
struct sunghoyazazaApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if ScreenTimeVM.shared.requestAuthorizationStatus() == .approved || true {
                    MainView()
                        .environmentObject(ScreenTimeVM.shared)
                }
                else {
                    StartPermissionView()
                        .environmentObject(ScreenTimeVM.shared)
                }
            }
        }
    }
}
