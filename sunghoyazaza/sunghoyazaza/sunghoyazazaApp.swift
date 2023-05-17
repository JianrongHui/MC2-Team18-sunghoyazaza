//
//  sunghoyazazaApp.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/07.
//

import SwiftUI

@main
struct sunghoyazazaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    VStack(alignment: .center) {
                        Spacer()
                        Image("mustsleep_80")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
                } else {
                    initView()
                }
            }
            .onReceive(ScreenTimeVM.shared.authorizationCenter.$authorizationStatus) { authStatus in
                ScreenTimeVM.shared.updateAuthorizationStatus(authStatus: authStatus)
            }
            .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                         isLoading.toggle()
                     })
            }
        }
        .onChange(of: scenePhase) { phase in
            NotificationManager.shared.updateHasNotificationPermission()
            NotificationManager.shared.updateAuthStatus()
            if phase == .active{
                DateModel.shared.reloadData()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
}
