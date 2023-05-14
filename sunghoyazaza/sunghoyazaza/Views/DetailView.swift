//
//  DetailView.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct DetailView: View {
    @State private var settingIndex = 0
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    
    let columns = [
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56))
    ]
    
    @State var startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    @State var endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State var selectedDays:[Bool] = UserDefaults.standard.array(forKey: "selectedDays") as? [Bool] ?? [Bool](repeating: false, count: 7)
    
    @State private var toggleIndex = true
    
    var body: some View {
        VStack(spacing: 0) {
            TabButtonView()
            if settingIndex == 0 {
                SettingTimeView()
            } else {
                SettingAppView()
            }
            Spacer()
        }
        .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
        .onAppear() {
            //MARK: 사용자가 기존에 설정한 시간값을 DateComponent타입에서 Date타입으로 변환하여 불러오기
            let userStartAt = ScreenTimeVM.shared.sleepStartDateComponent
            let userEndAt = ScreenTimeVM.shared.sleepEndDateComponent
            startAt = Calendar.current.date(from: userStartAt)!
            endAt = Calendar.current.date(from: userEndAt)!
            //MARK: 사용자가 기존에 설정한 제한 앱 불러오기
            selection = ScreenTimeVM.shared.selectionToDiscourage
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("수면 계획").font(.headline)
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("저장") {
                    //                        UserDefaults.standard.set(startAt, forKey: "startAt")
                    //                        UserDefaults.standard.set(endAt, forKey: "endAt")
                    //                        UserDefaults.standard.set(selectedDays, forKey: "selectedDays")
                    //MARK: 사용자 설정 값들을 저장 @AppStorage 변수에 저장
                    ScreenTimeVM.shared.sleepStartDateComponent = Calendar.current.dateComponents([.hour, .minute], from: startAt)
                    ScreenTimeVM.shared.sleepEndDateComponent = Calendar.current.dateComponents([.hour, .minute], from: endAt)
                    ScreenTimeVM.shared.selectionToDiscourage = selection
                    
                    //TODO: 수면 계획 모니터링 시작 -> 사용자 설정시간으로 넘겨주도록 수정 필요
                    ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
                        startTime: ScreenTimeVM.shared.sleepStartDateComponent,
                        endTime: ScreenTimeVM.shared.sleepEndDateComponent,
                        deviceActivityName: .dailySleep
                    )
                }
            }
        }
    }
}

// MARK: Views
extension DetailView {
    
    // MARK: 탭 버튼 UI
    func TabButtonView() -> some View {
        VStack {
            Picker("설정 선택", selection: $settingIndex, content: {
                Text("시간 설정").tag(0)
                Text("앱 설정").tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.all, .spacing24)
        }
    }
    
    // MARK: 시간 설정 탭
    func SettingTimeView() -> some View {
        VStack {
            VStack(spacing: .spacing24){
                // TODO: 앱 제한 기능 동작 시 추가하기
                //                RepeatDaysPicker(selectedDays: $selectedDays)
                DatePicker(selection: $startAt, displayedComponents: .hourAndMinute, label: { Text("취침시간") })
                DatePicker(selection: $endAt, displayedComponents: .hourAndMinute, label: { Text("기상시간") })
            }
            .padding(.vertical, .spacing16)
            .padding(.horizontal, .spacing24)
            VStack{
                VStack{
                    Toggle("시작전 알림", isOn: $toggleIndex)
                        .background(.white)
                    //                            .frame(height:56)
                }
                .padding(.horizontal, .spacing16)
                .frame(height:52)
                .background(Color.systemWhite)
                .cornerRadius(16)
                Text("자야 할 시간이 되기 5분 전에 알림을 받을 수 있고,\n약속한 15분이 끝나기 5분 전에 알림을 받을 수 있어요")
                    .padding([.top, .leading], .spacing8)
                    .font(.systemSubHeadline)
                    .foregroundColor(.systemGray)
            }
            .padding(.top, .spacing16)
            .padding(.horizontal, .spacing24)
        }
    }
    
    // MARK: 앱 설정 탭
    func SettingAppView() -> some View {
        VStack {
            SelectAppContainerView()
        }
    }
    
    // MARK: 앱 선택 컨테이너 뷰
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
    
    // MARK: 선택된 앱 리스트 뷰
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
}
