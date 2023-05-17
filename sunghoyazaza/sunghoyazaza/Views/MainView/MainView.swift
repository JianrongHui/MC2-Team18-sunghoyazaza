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
    @Environment(\.scenePhase) private var scenePhase
    @State var textIndex = MainVM().changeMainText() //
    @State var currentDate : Date = Date()
    @State var lottieHeight = CGFloat(600.0)
    @State var lottieWeight = CGFloat(320.0)
    @State var isLottieShow = true
    @State var mainLabel = MainModel().mainLabel
    @State var subLabel = MainModel().subLabel
    //MARK: 수면 계획 시간 변경 시 바로 뷰에 반영되도록 ScreenTimeVM을 ObservableObject로 사용
    @StateObject var screenTimeVM = ScreenTimeVM.shared
    @StateObject var mainModel = MainModel()
    var body: some View {
            ScrollView() {
                ZStack{
                    VStack {
//                        //MARK: 디버깅용 코드 (삭제 예정)
//                        Button {
//                            print("Activitiies: \(ScreenTimeVM.shared.deviceActivityCenter.activities)")
//                            if ScreenTimeVM.shared.deviceActivityCenter.schedule(for: .dailySleep) != nil {
//                                print("Schedule .dailySleep: \(ScreenTimeVM.shared.deviceActivityCenter.schedule(for: .dailySleep))\n")
//                            }
//                            if ScreenTimeVM.shared.deviceActivityCenter.schedule(for: .additionalTime) != nil {
//                                print("Schedule .additionalFifteen: \(ScreenTimeVM.shared.deviceActivityCenter.schedule(for: .additionalTime))\n")
//                            }
//                            print("additionalCount: \(ScreenTimeVM.shared.additionalCount)")
//                            print("isEndPoint: \(ScreenTimeVM.shared.isEndPoint.description)")
//
//                        } label: {
//                            Text("액티비티 조회")
//                        }//여기까지 디버깅용 코드
                        // 메인 Text
                        Text("\(mainLabel)")
                            .font(.largeTitle.bold())
                            .tracking(-1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, .spacing4)
                        
                        // 서브 Text (문구 랜덤 생성)
                        Text("\(subLabel)")
                            .tracking(-1)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, .spacing8)
                        
                        //캘린더
                        CalendarView(currentDate: $currentDate)
                            .padding(.vertical)
//                            .frame(maxHeight: .infinity)
                            .background(Color.systemWhite)
                            .cornerRadius(16)
                        
                        HStack {
                            //수면계획 택스트
                            Text("수면 계획")
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
                        //MARK: DetailView에서 값 변경 시 바로 반영됨
                        SleepPlanTopView(weekDay: MainModel().weekDay, sleepTime: screenTimeVM.sleepStartString, wakeupTime: screenTimeVM.sleepEndString)
                        //차단된 앱 알려주는 View
                        SleepPlanBottomView()
                    }
                    .padding([.top, .horizontal], .spacing24)
                    .background(Color.systemGray6.edgesIgnoringSafeArea(.all))
                    .navigationBarBackButtonHidden(true)
                    .onAppear{
                        print("what is grade? : ",DateModel.shared.grade)
                    }

                    if ScreenTimeVM.shared.isUserInitStatus {
                        LottieView(lottieFile: "LottieFile")
                            .frame(width: lottieWeight, height: lottieHeight)
                            .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.8){
                                        ScreenTimeVM.shared.isUserInitStatus = false
                                    }
                            }
                            .frame(maxWidth: lottieWeight, maxHeight: lottieHeight)
                    }
                }
            }
            .background(Color.systemGray6.edgesIgnoringSafeArea(.all))
            .onAppear {
                if ScreenTimeVM.shared.isUserInitStatus {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.8){
                    }
                }
                
            } .onChange(of: scenePhase) { phase in
                mainLabel = MainModel().mainLabel
            }
    }
}
