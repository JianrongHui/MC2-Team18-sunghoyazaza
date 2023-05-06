//
//  ContentView.swift
//  SungHozaza
//
//  Created by Seokmin on 2023/05/02.
//
//MARK: 앱의 메인 화면

import SwiftUI

struct MainView: View {
    @State var textIndex = changeMainText()
    @State var currentDate : Date = Date()
    
    var body: some View {
//        ScrollView{  //꽉찬 뷰 해결방법?
            VStack(spacing: 0){
                HStack{
                    VStack{
                            Text("\(mainLabel[textIndex])")
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 34))
                                .padding(.horizontal)
                                .bold()
                    }
                    .padding(.top, 17)
                }
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        Text("\(subLabel[textIndex])")
                            .font(.system(size: 17))
                            .padding(.horizontal)
                            .foregroundColor(Color(hex: 0x8E8E93))
                        Spacer()
                    }
                }
                CalendarView(currentDate: $currentDate)
                    .padding(.vertical)
                    .cornerRadius(24)
                    .frame(height: 393)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                    
                
                HStack{
                    Text("수면 계획")
                        .padding(.horizontal)
                    Spacer()
                    Button {
                        print("Edit Pressed")
                    } label: {
                        Text("편집")
                    }
                    .padding(.horizontal)
                    
                }
                Spacer()
                
                SleepPlanTopView()
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                SleepPlanBottomView()
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
            .background(Color(hex: 0xF0F0F5).edgesIgnoringSafeArea(.all))
//        }
//        .background(Color(hex: 0xF0F0F5).edgesIgnoringSafeArea(.all))
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

