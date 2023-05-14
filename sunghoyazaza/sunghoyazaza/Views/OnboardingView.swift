//
//  OnboardingView.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls

struct OnboardingView: View {
    @State var startAt = UserDefaults.standard.object(forKey: "startAt") as? Date ?? Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    @State var endAt = UserDefaults.standard.object(forKey: "endAt") as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
    @State var selectedDays:[Bool] = UserDefaults.standard.array(forKey: "selectedDays") as? [Bool] ?? [Bool](repeating: false, count: 7)
    
    var body: some View {
        VStack { //(spacing: 24)
            VStack(alignment: .leading, spacing: 8) {
                Text("수면 루틴을 설정해주세요").font(.largeTitle.bold())
                Text("7시간 이상의 숙면은 내일 집중할 수 있게 도와줘요").foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, .spacing32)
            
            //RepeatDaysPicker(selectedDays: $selectedDays)
            
            //            Spacer().frame(height: 0)
            
            DatePicker(selection: $startAt, displayedComponents: .hourAndMinute, label: { Text("🌙 취침 시간") })
                .padding(.bottom, .spacing24)
            DatePicker(selection: $endAt, displayedComponents: .hourAndMinute, label: { Text("🔔 기상 시간") })
            
            Spacer()
            
            NavigationLink(destination: Onboarding2View()) {
                Text("수면 루틴 설정 완료").foregroundColor(.white)
            }.simultaneousGesture(TapGesture().onEnded{
                UserDefaults.standard.set(startAt, forKey: "startAt")
                UserDefaults.standard.set(endAt, forKey: "endAt")
                UserDefaults.standard.set(selectedDays, forKey: "selectedDays")
            })
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding([.bottom, .horizontal], .spacing24)
        .padding(.top, .spacing32)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("수면 루틴 설정")
                        .font(.headline)
                }
            }
        }
        .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
    }
}

struct RepeatDaysPicker: View {
    let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    @Binding var selectedDays:[Bool]
    
    var body: some View {
        VStack {
            HStack {
                Text("요일 선택")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)

                Spacer()
                if selectedDays == [Bool](repeating: true, count: 7) {
                    Button("전체 취소") {
                        selectedDays = [Bool](repeating: false, count: 7)
                    }.font(.subheadline).padding(.horizontal, 10.0).padding(.vertical, 4.0)
                        .background(.white)
                        .border(.white, width: 0)
                        .cornerRadius(16)
                }
                else {
                    Button("전체 반복") {
                        selectedDays = [Bool](repeating: true, count: 7)
                    }.font(.subheadline).padding(.horizontal, 10.0).padding(.vertical, 4.0)
                        .background(.white)
                        .border(.white, width: 0)
                        .cornerRadius(16)
                }
            }
            HStack {
                ForEach(0 ..< daysOfWeek.count, id: \.self) { index in
                    Button(action: {
                        if selectedDays[index] {
                            selectedDays[index] = false
                        } else {
                            selectedDays[index] = true
                        }
                    }) {
                        Text(daysOfWeek[index])
                            .font(.system(size: 17))
                            .fontWeight(selectedDays[index] ? .bold : .regular)
                            .foregroundColor(selectedDays[index] ? Color.accentColor : .black)
                    }
                    .frame(width: 44, height: 44)
                    .background(selectedDays[index] ? Color.accentColor.opacity(0.2) : Color.systemGray5)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity)
                }
            }.padding(.vertical, 6.0)
        }
    }
}
