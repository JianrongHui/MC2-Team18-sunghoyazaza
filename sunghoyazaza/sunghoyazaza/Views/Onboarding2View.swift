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
        VStack(spacing: .spacing24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("제한할 앱을 설정해주세요").font(.largeTitle.bold())
                Text("SNS, 영상 컨텐츠 등을 제한하는 것을 추천해요").foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            // TODO::Pick interface
            
            // VERSION 1
            VStack(spacing: .spacing12) {
                HStack {
                    Text("제한 중인 앱 목록").font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button("편집") { isPresented = true }
                        .familyActivityPicker(isPresented: $isPresented,
                                              selection: $selection)
                }
                
                // 앱 아이콘 나오는 부분
                ForEach (0 ..< selection.applicationTokens.count, id: \.self) { index in
                    Label(Array(selection.applicationTokens)[index])
                }
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray)
                    .frame(height: 120)
            }
            
            //            ForEach (selection.applicationTokens) { application in
            //                Label(application)
            //            }
            
            Spacer()
            
            NavigationLink(destination: {
                MainView()
            }) {
                Text("제한할 앱 설정 완료").foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding([.bottom, .horizontal], .spacing24)
        .padding(.top, .spacing32)
        //            .navigationBarTitleDisplayMode(.inline)
        //            .toolbar {
        //                ToolbarItem(placement: .principal) {
        //                    VStack {
        //                        Text("수면계획 설정").font(.headline)
        //                    }
        //                }
        //            }
        .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
    }
}
