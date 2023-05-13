//
//  PermissionView.swift
//  sunghoyazaza
//
//  Created by JAESEOK LEE on 2023/05/11.
//

import SwiftUI

struct PermissionView: View {
    
    @StateObject
    var vm = PermissionViewModel()
    
    private var pageContents =
    """
    머스트 슬립은 아래 기능들에
    대한 권한 설정이 필요해요
    권한 설정을 완료하면
    첫 수면 계획을 만들러 갈 수 있어요
    """
       
    @State
    private var isNavigationActive = false
        
    var body: some View {
        VStack{
            pageTitleView()
            RequestPermissionButtonView()
                .padding([.top, .horizontal], .spacing24)
            Spacer()
            //MARK: 16.0 이상 was deprecated
            GoToOnboardingButtonView()
        }
        .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
        .onAppear {
            NotificationManager.shared.requestAuthStatus()
            print(NotificationManager.shared.hasNotificationPermission)
            vm.updatePermissionStatus()
        }
        .onReceive(ScreenTimeVM.shared.authorizationCenter.$authorizationStatus) { authStatus in
            ScreenTimeVM.shared.updateAuthorizationStatus(authStatus: authStatus)
            vm.updatePermissionStatus()
        }
    }
}

// MARK: Views
extension PermissionView {
    
    // MARK: 타이틀
    func pageTitleView() -> some View {
        Text(pageContents)
            .font(Font.systemTitle3)
            .multilineTextAlignment(.center)
            .padding([.horizontal, .bottom], .spacing16)
            .padding(.top, .spacing56)
            .frame(maxWidth: .infinity)
    }
    
    // MARK: 권한요청 버튼 리스트
    func RequestPermissionButtonView() -> some View {
        VStack(alignment: .leading, spacing: .spacing24) {
            RequestButtonView(
                staticInfo: vm.notificationButtonInfo,
                buttonStatus: vm.notificationButtonStatus,
                hasPermission: vm.hasNotificationPermission
            )
            RequestButtonView(
                staticInfo: vm.screenTimeButtonInfo,
                buttonStatus: vm.screenTimeButtonStatus,
                hasPermission: vm.hasScreenTimePermission
            )
        }
    }

    // MARK: 권한요청 버튼
    func RequestButtonView(
        staticInfo: PermissionButtonInfo,
        buttonStatus: PermissionButtonStatus,
        hasPermission: Bool) -> some View {
        VStack(alignment: .leading ,spacing: 0) {
            // sectionHeader
            HStack(spacing: 0) {
                Text(staticInfo.headerText)
                    .font(.systemSubInfo)
                    .foregroundColor(.systemGray2)
                    .padding(.trailing, .spacing2)
                Image(systemName: buttonStatus.img)
                    .font(.systemSubInfo)
                    .foregroundColor(buttonStatus.color)
            }
            .padding(.leading, .spacing8)
            .padding(.bottom, .spacing4)
            // sectionBody
            Button {
                vm.handlePermissionButton(permissionName: staticInfo.permissionName)
            } label: {
                HStack{
                    Image(staticInfo.src)
                    Text(staticInfo.permissionName)
                        .tint(Color.systemBlack)
                    Spacer()
                    Text(buttonStatus.label)
                        .frame(width: 100, height: 50)
                        .foregroundColor(hasPermission ? Color.systemGray2 : Color.primary)
                }
                .padding([.leading, .vertical], .spacing16)
                .padding(.trailing, .spacing8)
            }
            .disabled(hasPermission)
            .background(hasPermission ? Color.systemGray4 : Color.systemWhite)
            .cornerRadius(16)
            .padding(.bottom, .spacing8)
            // sectionFooter
            Text(staticInfo.footerText)
                .font(Font.systemSubHeadline)
                .foregroundColor(.systemGray)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                .padding(.leading, .spacing8)
        }
    }
    
    // MARK: 시작하기 버튼
    func GoToOnboardingButtonView() -> some View{
        NavigationLink("시작하기", destination: OnboardingView(), isActive: $isNavigationActive)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(
                vm.hasScreenTimePermission ? .systemWhite : .systemGray2)
            .background(vm.hasScreenTimePermission ? Color.accentColor : Color.systemGray4)
            .disabled(!vm.hasScreenTimePermission)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding([.horizontal, .bottom], CGFloat.spacing24)
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
