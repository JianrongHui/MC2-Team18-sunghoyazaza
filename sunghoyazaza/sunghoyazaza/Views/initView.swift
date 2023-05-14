//
//  initView.swift
//  sunghoyazaza
//
//  Created by Yun Dongbeom on 2023/05/15.
//

import SwiftUI

struct initView: View {
    var body: some View {
        NavigationView {
            if !ScreenTimeVM.shared.isUserInitStatus && ScreenTimeVM.shared.authorizationCenter.authorizationStatus == .approved  {
                MainView()
            }
            else {
                Onboarding0View()
            }
        }
        .environmentObject(ScreenTimeVM.shared)
    }
}

struct initView_Previews: PreviewProvider {
    static var previews: some View {
        initView()
    }
}
