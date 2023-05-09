//
//  sunghoyazazaApp.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/07.
//

import SwiftUI

@main
struct sunghoyazazaApp: App {
    
    @StateObject
    var screenTimeVM = ScreenTimeVM.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if screenTimeVM.requestAuthorizationStatus() == .approved {
                    MainView(screenTimeVM: screenTimeVM)
                }
                else {
                    StartPermissionView(screenTimeVM: screenTimeVM)
                }
            }
        }
    }
}
