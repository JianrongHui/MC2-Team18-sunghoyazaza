//
//  PermissionView.swift
//  sunghoyazaza
//
//  Created by JAESEOK LEE on 2023/05/11.
//

import SwiftUI
import FamilyControls

struct PermissionView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject
    private var vm = PermissionViewModel()
    
    @State
    private var isNavigationActive = false
    
    @State
    private var showAlert = false
    
    private let pageContents =
    """
    머스트 슬립은
    아래와 같은 권한 설정이 필요해요
    권한 설정을 완료하면
    첫 수면 계획을 만들러 갈 수 있어요
    """
    
    var body: some View {
        VStack{
            PageTitleView()
            RequestPermissionButtonView()
                .alert(
                    "알림이 이전에 거부되었어요",
                    isPresented: $showAlert
                ) {
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    } label: {
                        Text("설정으로 가기")
                    }
                    Button(role: .cancel) {
                    } label: {
                        Text("닫기")
                    }
                } message: {
                    Text("알림은 한 번 거부되면 설정에서 변경해야 해요 설정에서 알림을 허용해 주세요")
                }
                .padding([.top, .horizontal], .spacing24)
            Spacer()
            //MARK: 16.0 이상 was deprecated
            GoToOnboardingButtonView()
        }
        .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
        .onAppear {
            vm.updatePermissionStatus()
        }
        .onChange(of: ScreenTimeVM.shared.authorizationCenter.authorizationStatus) {
            authStatus in
            vm.updatePermissionStatus()
        }
        .onReceive(NotificationManager.shared.$sharedHasNotificationPermission) { status in
            vm.updatePermissionStatus()
        }
        .onReceive(ScreenTimeVM.shared.$sharedHasScreenTimePermission) { authStatus in
            vm.updatePermissionStatus()
        }
    }
}

// MARK: Views
extension PermissionView {
    
    // MARK: 타이틀
    private func PageTitleView() -> some View {
        Text(pageContents)
            .font(Font.systemTitle3)
            .multilineTextAlignment(.center)
            .padding([.horizontal, .bottom], .spacing16)
            .padding(.top, .spacing24)
            .frame(maxWidth: .infinity)
    }
    
    // MARK: 권한요청 버튼 리스트
    private func RequestPermissionButtonView() -> some View {
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
    private func RequestButtonView(
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
                if staticInfo.permissionName == "알림" && NotificationManager.shared.sharedHasNotificationPermission == 0 {
                    showAlert = true
                }
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
    private func GoToOnboardingButtonView() -> some View{
        VStack {
            Button {
                ScreenTimeVM.shared.requestAuthorization()
                isNavigationActive = true
            } label: {
                Text("첫 수면 계획 만들러 가기")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(
                vm.hasScreenTimePermission ? .systemWhite : .systemGray2)
            .background(vm.hasScreenTimePermission ? Color.accentColor : Color.systemGray4)
            .disabled(!vm.hasScreenTimePermission)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding([.horizontal, .bottom], CGFloat.spacing24)
            NavigationLink(destination: OnboardingView(), isActive: $isNavigationActive) {
                EmptyView()
            }
        }
    }
}
