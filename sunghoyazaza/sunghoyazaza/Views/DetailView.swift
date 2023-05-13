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
    @State var selection = ScreenTimeVM.shared.selectionToDiscourage
    @State var isPresented = false
    @State var startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    @State var endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State var selectedDays:[Bool] = UserDefaults.standard.array(forKey: "selectedDays") as? [Bool] ?? [Bool](repeating: false, count: 7)
    
    @State private var toggleIndex = true

    var body: some View {
        VStack(spacing: 0) {
            Picker("설정 선택", selection: $settingIndex, content: {
                Text("시간 설정").tag(0)
                Text("앱 설정").tag(1)
            })
            .pickerStyle(SegmentedPickerStyle())
            .frame(height: 80)
            .padding(.horizontal,24)
            
            if settingIndex == 0 {
             //   RepeatDaysPicker(selectedDays: $selectedDays)
                
                Spacer().frame(height: 0)
                VStack(spacing:24){
                    DatePicker(selection: $startAt, displayedComponents: .hourAndMinute, label: { Text("취침시간") })
                        .padding(.horizontal,24)
                    DatePicker(selection: $endAt, displayedComponents: .hourAndMinute, label: { Text("기상시간") })
                        .padding(.horizontal,24)
                }.frame(height:128)
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
                    .padding(.horizontal,24)

                
                
            }else {
                HStack {
                    Text("제한 중인 앱 목록")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Spacer()
                    Button("편집") { isPresented = true }
                        .familyActivityPicker(isPresented: $isPresented,
                                              selection: $selection)
                        .padding(.horizontal,25)
                        .background(.white)
                        .border(.white, width: 0)
                        .cornerRadius(20)
                }.padding(.horizontal,24)
                
                Spacer().frame(height: 8.0)
                
                // 앱 아이콘 나오는 부분
//                ForEach (0 ..< selection.applicationTokens.count, id: \.self) { index in
//                    Label(Array(selection.applicationTokens)[index])
//                }
            }
            
            Spacer()
        }.background(Color.systemGray6)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("수면 계획").font(.headline)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        UserDefaults.standard.set(startAt, forKey: "startAt")
                        UserDefaults.standard.set(endAt, forKey: "endAt")
                        UserDefaults.standard.set(selectedDays, forKey: "selectedDays")
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
