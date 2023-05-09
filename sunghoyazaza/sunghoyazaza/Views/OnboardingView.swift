//
//  OnboardingView.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls

struct OnboardingView: View {
    @State var repeatDays: [String] = []
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("계획한 수면 시간을 설정해주세요").font(.largeTitle.bold())
                Text("7시간 이상의 숙면은 내일의 집중을 도와줍니다.").foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            RepeatDaysPicker()
            
            Spacer().frame(height: 0)
            
            DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, displayedComponents: .hourAndMinute, label: { Text("취침시간") })
            
            DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, displayedComponents: .hourAndMinute, label: { Text("기상시간") })
            
            Spacer()
            
            NavigationLink(destination: Onboarding2View()) {
                Text("설정 완료").foregroundColor(.white)
            }.padding()
                .frame(width: 240)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("수면계획 설정").font(.headline)
                    }
                }
            }
    }
}

struct RepeatDaysPicker: View {
    let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    @State var selectedDays: Set<String> = []
    
    var body: some View {
        VStack {
            HStack {
                Text("반복일 설정").font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button("전체반복") {
                    for day in daysOfWeek {
                        selectedDays.insert(day)
                    }
                }
            }
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Button(action: {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }) {
                        Text(day)
                            .font(.system(size: 18))
                            .fontWeight(selectedDays.contains(day) ? .bold : .regular)
                            .foregroundColor(selectedDays.contains(day) ? Color.accentColor : .black)
                    }
                    .frame(width: 44, height: 44)
                    .background(selectedDays.contains(day) ? Color.accentColor.opacity(0.1) : Color.white)
                    .cornerRadius(50)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
