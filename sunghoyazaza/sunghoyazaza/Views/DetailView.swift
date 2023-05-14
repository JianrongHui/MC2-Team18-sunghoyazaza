//
//  DetailView.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls

struct DetailView: View {
    @State private var settingIndex = 0
    @State var selection = FamilyActivitySelection()
    @State var isPresented = false
    @State var startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    @State var endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State var selectedDays:[Bool] = UserDefaults.standard.array(forKey: "selectedDays") as? [Bool] ?? [Bool](repeating: false, count: 7)
    
    var body: some View {
        VStack(spacing: 24) {
            Picker("설정 선택", selection: $settingIndex, content: {
                Text("시간 설정").tag(0)
                Text("앱 설정").tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer().frame(height: 0)
            
            if settingIndex == 0 {
                RepeatDaysPicker(selectedDays: $selectedDays)
                
                Spacer().frame(height: 0)
                
                DatePicker(selection: $startAt, displayedComponents: .hourAndMinute, label: { Text("취침시간") })
                
                DatePicker(selection: $endAt, displayedComponents: .hourAndMinute, label: { Text("기상시간") })

            }
            else {
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
//                ForEach (0 ..< selection.applicationTokens.count, id: \.self) { index in
//                    Label(Array(selection.applicationTokens)[index])
//                }
            }
            
            Spacer()
        }
        .onAppear() {
            // MARK: 사용자가 기존에 설정한 시간값을 DateComponent타입에서 Date타입으로 변환하여 불러오기
            let userStartAt = ScreenTimeVM.shared.sleepStartDateComponent
            let userEndAt = ScreenTimeVM.shared.sleepEndDateComponent
            startAt = Calendar.current.date(from: userStartAt)!
            endAt = Calendar.current.date(from: userEndAt)!
            //MARK: 사용자가 기존에 설정한 제한 앱 불러오기
            selection = ScreenTimeVM.shared.selectionToDiscourage
        }
        .padding()
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
