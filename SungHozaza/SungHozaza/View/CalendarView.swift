//
//  CalendarView.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/07.
//
//MARK: 캘린더 뷰

import SwiftUI

struct CalendarView: View {
    
    //MARK: Database
    @Binding var currentDate : Date //현재 날짜
    @State var currentMonth : Int = 0 // 화살표 클릭으로 인한 월 세는 변수
    let days: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"] //달력 상단 요일
    let columns = Array(repeating: GridItem(.flexible()), count: 7) //달력 틀
    
    //MARK: MAIN
    var body: some View {
        // 전체 Stack
        VStack(spacing: 10){
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
                        .foregroundColor(Color(hex: 0x0F0094))
                }
                
                // 우화살표 버튼
                Button {
                        currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color(hex: 0x0F0094))
                }
            }
            .padding(.horizontal)
            
            // 상단 요일 Stack
            HStack(spacing: 0){
                ForEach(days,id: \.self){day in
                    Text(day)
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            
            // LazyGrid를 사용한 달력 그리기
            LazyVGrid(columns: columns, spacing: 15){
                ForEach(extractDate()){ value in
                    CardView(value: value)
                        .background(
                        Capsule()
                            .fill(Color(hex: 0x0F0094))
                            .padding(.horizontal, 10)
                            .opacity(isSameDay(date1: value.date, date2: currentDate) ? 0.3 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                    
                }
            }
            Spacer()
            
        }
        .onChange(of: currentMonth){newValue in
            //updating Month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue)->some View{
        VStack{
            if value.day != -1{
                
                if let task = datesHavingDots.first(where: {task in
                    return isSameDay(date1: task.date, date2: value.date)
                }){
                    Text("\(value.day)")
                        .foregroundColor(isSameDay(date1: task.date, date2: currentDate) ? Color(hex: 0x0F0094) : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: task.date, date2: currentDate) ? Color(hex: 0x0F0094) : Color(hex: 0x0F0094))
                        .frame(width: 8, height: 8)
                    
                }
                else{
                    
                    Text("\(value.day)")
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? Color(hex: 0x0F0094) : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 35,alignment: .top)
    }
    
    //checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    // extracting year and month for display
    func extraDate()->[String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    
    func getCurrentMonth()->Date{
        
        let calendar = Calendar.current
        
        //Getting Current Month Date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
    }
    
    
    func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        //Getting Current Month Date
        let currentMonth = getCurrentMonth()
        
        var days =  currentMonth.getAllDates().compactMap{
            date -> DateValue in
            
            //getting day
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

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


//Extending Dates to get Current Month Dates

extension Date{
    func getAllDates()->[Date]{
        
        let calendar = Calendar.current
        
        
        // getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
}

