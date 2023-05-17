//
//  CalendarView.swift
//  sunghoyazaza
//
//  Created by 077tech on 2023/05/07.
//
//MARK: 캘린더 뷰

import SwiftUI

struct CalendarView: View {
    let dateFormatter = DateFormatter()
    
    @StateObject
    var dateModel = DateModel.shared
    
    @Binding var currentDate : Date //현재 날짜
    @State var currentMonth : Int = 0 // 화살표 클릭으로 인한 월 세는 변수
    
    //MARK: Database
    let days: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7) //달력 틀
    
    
    //MARK: MAIN
    var body: some View {
        // 전체 Stack
        VStack(spacing: 10) {
            // 월, 년도, 좌화살표, 우화살표 포함 Stack
            HStack(spacing: 20){
                // 월, 년도 Stack
                HStack(spacing: 5){
                    // 월 Text (ex. May)
                    Text(extraDate()[1])
                        .font(.system(size: 17))
                        .bold()
                    
                    // 년도 Text (ex. 2023)
                    Text(extraDate()[0])
                        .font(.system(size: 17))
                        .bold()
                }
                Spacer(minLength: 0)
                
                // 좌화살표 버튼
                Button {
                    currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color.accentColor)
                }
                
                // 우화살표 버튼
                Button {
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color.accentColor)
                }
            }
            .padding(.horizontal, .spacing16)
            .padding(.bottom)
            
            // 상단 요일 Stack
            HStack(spacing: 0){
                ForEach(days,id: \.self){day in
                    Text(day)
//                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 2)
            
            // LazyGrid를 사용한 달력 그리기
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(extractDate()){ value in
                    CardView(value: value)
                        .background(
                            Capsule() //선택 시 생기는 파란색 원
                                .fill(Color.accentColor)
                                .padding(.horizontal, 10)
                                .opacity(isSameDay(date1: value.date, date2: Date()) ? 0.3 : 0)
                        )
                }
            }
            .padding(.horizontal, 6)
            
            Spacer()
            
            
        }
        // 월 변경시 새로운 월 업데이트
        .onChange(of: currentMonth){newValue in
            currentDate = getCurrentMonth()
        }
    }
    
    // 달력 각각 날짜 뷰
    @ViewBuilder
    func CardView(value: DateValue)->some View{
        // 날짜 하루 + 수면 계획 성공 여부 Stack
        VStack{
            // 수면 계획 성공한 날짜 코드
            if value.day != -1{
                if let record = dateModel.records[value.key]{
                    if record.type == .success{
                        Text("\(value.day)")
                            .foregroundColor(.systemBlack)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color(hex: 0x0F0094))
                            .frame(width: 8, height: 8)
                    }else{
                        Text("\(value.day)")
                            .foregroundColor(.systemBlack)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    
                }
                // 수면 계획 실패 + 미래 날짜 코드
                else{
                    Text("\(value.day)")
                        .foregroundColor(.systemBlack)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 36, alignment: .top)
    }

    //MARK: 날짜 확인 코드
    private func isSameDay(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    //MARK: YYYY MMMM 형태로 날짜 형식 바꾸는 함수
    private func extraDate()->[String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    
    //MARK: 현재 월 반환해주는 함수
    private func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        //Getting Current Month Date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
    }
    
    //MARK: 날짜 추출해주는 함수
    private func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        //현재 월 반환
        let currentMonth = getCurrentMonth()
        
        var days =  currentMonth.getAllDates().compactMap{
            date -> DateValue in
            
            //날짜 반환
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}
