//
//  ContentView.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/02.
//

//MARK: 앱의 메인 화면
import SwiftUI
import ManagedSettings
//import Lottie

struct MainView: View {
    @State var textIndex = MainVM().changeMainText() //
    @State var currentDate : Date = Date()
    let mainModel = MainModel()
    @State var lottieHeight = CGFloat(800.0)
    @State var lottieWeight = CGFloat(380.0)
    
    var body: some View {
        ZStack{
            //        ScrollView{  //꽉찬 뷰 해결방법?
            //전체 뷰 Stack
            ScrollView() {
                VStack {
                    
                    // 메인 Text
                    Text("\(mainModel.mainLabel)")
                        .font(.largeTitle.bold())
                        .tracking(-1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .spacing4)
                    
                    // 서브 Text (문구 랜덤 생성)
                    Text("\(mainModel.subLabel)")
                        .tracking(-1)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .spacing8)
                    //테스트용 버튼
//                    Button {
//                        print("Start: \(ScreenTimeVM.shared.sleepStartDateComponent)")
//                        print("End: \(ScreenTimeVM.shared.sleepEndDateComponent)")
//                        let managedSettingsStore = ManagedSettingsStore(named: .dailySleep)
//                        managedSettingsStore.shield.applications = ScreenTimeVM.shared.selectionToDiscourage.applicationTokens.isEmpty ? nil : ScreenTimeVM.shared.selectionToDiscourage.applicationTokens
//                        managedSettingsStore.shield.applicationCategories = ScreenTimeVM.shared.selectionToDiscourage.categoryTokens.isEmpty
//                        ? nil
//                        : ShieldSettings.ActivityCategoryPolicy.specific(ScreenTimeVM.shared.selectionToDiscourage.categoryTokens)
//                    } label: {
//                        Text("쉴드 적용")
//                    }

                    //캘린더
                    CalendarView(currentDate: $currentDate)
                        .padding(.vertical)
                        .frame(maxHeight: .infinity)
                        .background(Color.systemWhite)
                        .cornerRadius(16)
                    
                    HStack {
                        //수면계획 택스트
                        Text("수면 계획")
//                            .padding(.horizontal)
                        
                        Spacer()
                        
                        // 편집 버튼
                        NavigationLink(
                            destination: DetailView(),
                            label: { Text("편집").foregroundColor(Color.accentColor) }
                        )
                        .padding(.horizontal)
                        .padding(.vertical, .spacing4)
                        .background(Color.systemWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, .spacing4)
                    
                    //취침 및 기상시간 알려주는 View
                    SleepPlanTopView(weekDay: MainModel().weekDay, sleepTime: MainModel().sleepTime, wakeupTime: MainModel().wakeupTime)
//                        .padding(.horizontal)
                    //차단된 앱 알려주는 View
                    SleepPlanBottomView()
//                        .padding(.horizontal)
                
                }
                .padding([.top, .horizontal], .spacing24)
                .background(Color.systemGray6.edgesIgnoringSafeArea(.all))
                .navigationBarBackButtonHidden(true)
                .onAppear{
                    print("what is grade? : ",DateModel.shared.grade)
                    let now = Date()
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: now)

                    print(hour)
                }
                // TODO: Lottie 파일 없음 해결 필요
                //if newbie == 0{
//                LottieView(lottieFile: "lottieSuccess")
//                    .frame(width: lottieWeight, height: lottieHeight)
//                    .onAppear{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8){
//                            lottieWeight = 0
//                            lottieHeight = 0
//                        }
//                    }
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                //.onAppear {
                //newbie = 1
                //       }
                //    }
            }
            
            .background(Color.systemGray6.edgesIgnoringSafeArea(.all))
        }
    }
}

//MARK: PREVIEW
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

