//
//  SleepPlanBottomView.swift
//  sunghoyazaza
//
//  Created by 077tech on 2023/05/07.
//
//MARK: 차단된 앱 로고 표시 화면

import SwiftUI
import FamilyControls
import ManagedSettings

struct SleepPlanBottomView: View {
    @State private var dataCount = MainVM().blockApplicationCount()
    
    @State private var selection = FamilyActivitySelection() {
        didSet {
            ScreenTimeVM.shared.selectionToDiscourage = selection
        }
    }

    private let columns = [
        GridItem(.fixed(36)),
        GridItem(.fixed(36)),
        GridItem(.fixed(36)),
        GridItem(.fixed(36)),
        GridItem(.fixed(36)),
        GridItem(.fixed(36)),
        GridItem(.fixed(36))
    ]
    
    var body: some View {
        
        // 차단된 앱 개수 변수
        // 전체 Stack
        VStack {
            if (selection.applicationTokens.count > 0 || selection.categoryTokens.count > 0) {
                LazyVGrid(columns: columns, spacing: 10){
                    if selection.applicationTokens.count > 0 {
                        ForEach(Array(selection.applicationTokens), id: \.self) {
                            token in
                            HStack {
                                Label(token)
                                    .labelStyle(.iconOnly).scaleEffect(1.67)
                            }
                        }
                    }
                    if selection.categoryTokens.count > 0 {
                        ForEach(Array(selection.categoryTokens), id: \.self) {
                            token in
                            HStack {
                                Label(token)
                                    .labelStyle(.iconOnly).scaleEffect(1.2)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            else {
                Text("선택된 앱이 없습니다.")
                    .padding(.spacing20)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 40)
        .padding(.vertical, .spacing20)
        .background(Color.primary3)
        .cornerRadius(24)
        .onAppear() {
            //MARK: 사용자가 기존에 설정한 제한 앱 불러오기
            selection = ScreenTimeVM.shared.selectionToDiscourage
        }
    }
}
