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
                if ScreenTimeVM.shared.requestAuthorizationStatus() == .approved {
                    MainView()
                }
                else {
                    Onboarding0View()
                }
            }
            .environmentObject(ScreenTimeVM.shared)
        }
    }
}
