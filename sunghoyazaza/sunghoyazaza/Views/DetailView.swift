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
    var tokens: [ApplicationToken] {
        didSet {
            print("GGG!")
        }
    }
    
    init() {
        self.tokens = Array(ScreenTimeVM.shared.selectionToDiscourage.applicationTokens)
        print(ScreenTimeVM.shared.selectionToDiscourage)
    }
    
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
            Spacer().frame(height: 24.0)
            
            Picker("설정 선택", selection: $settingIndex, content: {
                Text("시간 설정").tag(0)
                Text("앱 설정").tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer().frame(height: 24.0)
            
            if settingIndex == 0 {
                VStack(spacing:0){
                    RepeatDaysPicker(selectedDays: $selectedDays)
                    
                    Spacer().frame(height: 16.0)
                    
                    DatePicker(selection: $startAt, displayedComponents: .hourAndMinute, label: { Text("취침시간") })
                    
                    Spacer().frame(height: 24.0)
                    
                    DatePicker(selection: $endAt, displayedComponents: .hourAndMinute, label: { Text("기상시간") })
                }
                
                Spacer().frame(height: 24.0)
                
                VStack(spacing:8){
                    VStack{
                        Toggle("시작전 알림", isOn: $toggleIndex)
                            .padding(.horizontal,16)
                            .background(.white)
                        //                            .frame(height:56)
                    }.frame(height:56)
                        .background(.white)
                        .border(.white, width: 0)
                        .cornerRadius(20)
                    Text("자야 할 시간이 되기 5분 전에 알림을 받을 수 있고,\n약속한 15분이 끝나기 5분 전에 알림을 받을 수 있어요")
                        .padding(.horizontal,8)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hexString:"8E8E93"))
                }.frame(height:100)
            } else {
                HStack(spacing: 0) {
                    Text("제한 중인 앱 목록").font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button("편집") { isPresented = true }
                        .familyActivityPicker(isPresented: $isPresented,
                                              selection: $selection).font(.subheadline).padding(.horizontal, 10.0).padding(.vertical, 4.0)
                        .background(.white)
                        .border(.white, width: 0)
                        .cornerRadius(16)
                }
                
                Spacer().frame(height: 8.0)
                
                if (selection.applicationTokens.count > 0 || selection.categoryTokens.count > 0) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 18){
                        if selection.applicationTokens.count > 0 {
                            ForEach(Array(selection.applicationTokens), id: \.self) {
                                token in
                                HStack {
                                    Label(token)
                                        .labelStyle(.iconOnly)
                                        .scaleEffect(3)
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
                                        .scaleEffect(2.0)
                                }
                                .frame(width: 56, height: 56)
                            }
                        }
                    }
                    .padding(CGFloat.spacing16)
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .background(Color.primary3)
                    .cornerRadius(16)
                }
                else {
                    Text("선택된 앱이 없습니다.").foregroundColor(Color.systemGray)
                        .padding(CGFloat.spacing16)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.primary3)
                        .cornerRadius(16)
                }
                
                
            }
            
            Spacer()
            
        }.padding(.horizontal, 24)
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
                        // MARK: 사용자 설정 값들을 @AppStorage 변수에 저장
                        ScreenTimeVM.shared.sleepStartDateComponent = Calendar.current.dateComponents([.hour, .minute], from: startAt)
                        ScreenTimeVM.shared.sleepEndDateComponent = Calendar.current.dateComponents([.hour, .minute], from: endAt)
                        ScreenTimeVM.shared.selectionToDiscourage = selection
                        
                        // MARK: 수면 계획 모니터링 시작
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
