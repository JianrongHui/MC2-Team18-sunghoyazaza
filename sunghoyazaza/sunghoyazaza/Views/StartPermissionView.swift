//
//  StartPermissionView.swift
//  sunghoyazaza
//
//  Created by 077tech on 2023/05/06.
//
//MARK: 앱 시작 시 나오는 권한설정 화면

import SwiftUI

//MARK: MAIN
struct StartPermissionView: View {
    @EnvironmentObject var screenTimeVM: ScreenTimeVM
    @State var alarmOnOff : Bool = false
    @State var screenTimeAPIOnOff : Bool = false
    
    var body: some View {
        ZStack{
            Color.systemGray6.edgesIgnoringSafeArea(.all)
            VStack{
                //TODO: APP이름 정해지면 넣을 것
                Text("\"App Name\"은 \n아래 기능을 사용해요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .bold()
                    .font(.systemLargeTitle)
                Spacer()
                
                // 권한 설정 하기 버튼
                NavigationLink("시작하기", destination: OnboardingView())
                    .padding()
                    .frame(width: 240)
                    .foregroundColor(.white)
                    .background(screenTimeAPIOnOff ? Color.accentColor : Color.systemGray4)
                    .disabled(!screenTimeAPIOnOff)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            VStack{
                HStack{
                    if alarmOnOff == false {
                        Text("alarmOff")
                            .padding()
                    }else{
                        Text("alarmOn")
                            .padding()
                    }
                    Button {
                        print("alarm Notification Click")
                    } label: {
                        Text("alarm Notification")
                    }
                }
                HStack{
                    if screenTimeAPIOnOff == false {
                        Text("screenTimeAPIOff")
                            .padding()
                    }else{
                        Text("screenTimeAPIOn")
                            .padding()
                    }
                    Button {
                        print("screenNotificationAPI Notification Click")
                        ScreenTimeVM.shared.requestAuthorization()
                    } label: {
                        Text("screenNotificationAPI Notification")
                    }
                }
            }
        }    
    }
}

//MARK: PREVIEW
struct StartPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        StartPermissionView()
    }
}
