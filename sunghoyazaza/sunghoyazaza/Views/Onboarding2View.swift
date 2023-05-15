//
//  Onboarding2View.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct Onboarding2View: View {
    
    @State private var selection = FamilyActivitySelection()
    
    @State private var isPresented = false

    let columns = [
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            PageTitleView()
            SelectAppContainerView()
            Spacer()
            StartButtonView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("수면계획 설정")
                        .font(.headline)
                }
            }
        }
        .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
    }
}

//MARK: Views
extension Onboarding2View {
    
    // MARK: 페이지 타이틀
    func PageTitleView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("제한할 앱을 설정해주세요")
                    .font(.largeTitle.bold())
                Text("SNS, 영상 컨텐츠 등을 제한하는 것을 추천해요")
                    .foregroundColor(.gray)
            }
            .padding(CGFloat.spacing24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: 앱 선택 UI
    func SelectAppContainerView() -> some View {
        // TODO::Pick interface
        // VERSION 1
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text("제한 중인 앱 목록")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button("편집") { isPresented = true }
                    .familyActivityPicker(
                        isPresented: $isPresented,
                        selection: $selection)
                    .font(.subheadline)
                    .padding(.horizontal, 10.0)
                    .padding(.vertical, 4.0)
                    .background(.white)
                    .border(.white, width: 0)
                    .cornerRadius(16)
            }
            .padding(.horizontal, .spacing24)
            // 앱 아이콘 나오는 부분
            SelectedAppListView()
        }
    }
    
    func SelectedAppListView() -> some View {
        VStack {
            if (selection.applicationTokens.count > 0 || selection.categoryTokens.count > 0) {
                LazyVGrid(columns: columns, alignment: .leading){
                    if selection.applicationTokens.count > 0 {
                        ForEach(Array(selection.applicationTokens), id: \.self) {
                            token in
                            HStack {
                                Label(token)
                                    .labelStyle(.iconOnly)
                                    .scaleEffect(2.5)
                            }
                            .frame(width: 56, height: 56)
                        }
                    }
                    if selection.categoryTokens.count > 0 {
                        ForEach(Array(selection.categoryTokens), id: \.self) {
                            token in
                            HStack {
                                Label(token)
                                    .labelStyle(.iconOnly)
                                    .scaleEffect(1.8)
                            }
                            .frame(width: 56, height: 56)
                        }
                    }
                }
                .padding(.spacing16)
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color.primary3)
                .cornerRadius(16)
            } else {
                Text("선택된 앱이 없습니다.")
                    .foregroundColor(.systemGray)
                    .padding(.spacing16)
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .background(Color.primary3)
                    .cornerRadius(16)
            }
        }
        .padding(.top, .spacing8)
        .padding(.horizontal, .spacing24)
        
    }
    
    // MARK: 시작하기 버튼
    func StartButtonView() -> some View {
        NavigationLink(destination: {
            MainView()
        }) {
            Text("시작하기")
                .foregroundColor(.white)
        }
        .simultaneousGesture(TapGesture().onEnded{
            // MARK: 앱 선택 값을 뷰모델로 저장)
            ScreenTimeVM.shared.selectionToDiscourage = selection
            
            //TODO: 온보딩 시 수면 계획 모니터링 바로 시작할 지 논의
//            //MARK: 수면 계획 모니터링 시작
            ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
                startTime: ScreenTimeVM.shared.sleepStartDateComponent,
                endTime: ScreenTimeVM.shared.sleepEndDateComponent,
                deviceActivityName: .dailySleep
            )
            DateModel.shared.startDate = Date().toString()
            DateModel.shared.reloadData()
        })
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding([.bottom, .horizontal], .spacing24)
    }
}
