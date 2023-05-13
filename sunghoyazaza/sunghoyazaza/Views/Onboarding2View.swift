//
//  Onboarding2View.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls

struct Onboarding2View: View {
    
    @State var selection = ScreenTimeVM.shared.selectionToDiscourage
    @State var isPresented = false
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading, spacing: 8) {
                Text("사용을 제한할 앱을 선택해주세요").font(.largeTitle.bold())
                Text("7시간 이상의 숙면은 내일의 집중을 도와줍니다.").foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            // TODO::Pick interface
            
            // VERSION 1
            HStack {
                Text("제한 중인 앱 목록").font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button("편집") { isPresented = true }
                    .familyActivityPicker(isPresented: $isPresented,
                                          selection: $selection)
            }
            
            Spacer().frame(height: 8.0)
            
            // 앱 아이콘 나오는 부분
            ForEach (0 ..< selection.applicationTokens.count, id: \.self) { index in
                Label(Array(selection.applicationTokens)[index])
            }
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray)
                .frame(height: 120)
            
            
//            ForEach (selection.applicationTokens) { application in
//                Label(application)
//            }
            
            Spacer()
            
            NavigationLink(destination: {
                MainView()
            }) {
                Text("시작하기").foregroundColor(.white)
            }.padding()
                .frame(width: 240)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding().navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("수면계획 설정").font(.headline)
                    }
                }
            }
            .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
    }
}
