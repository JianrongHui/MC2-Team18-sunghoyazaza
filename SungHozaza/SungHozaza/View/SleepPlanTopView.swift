//
//  SleepPlanTopView.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/07.
//


import SwiftUI

struct SleepPlanTopView: View {
    
//MARK: DATABASE
    @State var weekDay : String = "월, 화, 수, 목, 금, 토, 일"
    @State var sleepTime : String = "11:00PM"
    @State var wakeupTime : String = "09:00AM"
    
    
//MARK: View
    var body: some View {
        HStack(spacing: 0){
            Image("sleepPlanImage")
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack{
                HStack{
                    Spacer()
                    Text("\(weekDay)")
                        .font(.system(size: 13))
                }
                .padding(.horizontal)
                HStack{
                    Text("취침시간")
                        .font(.system(size: 15))
                    Spacer()
                    Text("\(sleepTime)")
                        .font(.system(size: 28))
                        .foregroundColor((Color(hex: 0x0F0094)))
                        .bold()
                }
                .padding(.horizontal)
                HStack{
                    Text("기상시간")
                        .font(.system(size: 15))
                    Spacer()
                    Text("\(wakeupTime)")
                        .font(.system(size: 28))
                        .foregroundColor((Color(hex: 0x0F0094)))
                        .bold()
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(hex: 0xF6F8FF))
        .cornerRadius(24)
        
    }
}

struct SleepPlanTopView_Previews: PreviewProvider {
    static var previews: some View {
        SleepPlanTopView()
    }
}

