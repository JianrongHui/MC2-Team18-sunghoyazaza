//
//  Onboarding2View.swift
//  sunghoyazaza
//
//  Created by Seokmin on 2023/05/08.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ColorfulIconLabelStyle: LabelStyle {
    var color: Color
    var size: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title.hidden()
        } icon: {
            configuration.icon
                .aspectRatio(10, contentMode: .fill)
                .imageScale(.large)
                .frame(width: 50, height: 50)
        }
    }
}

struct Onboarding2View: View {
    
    @State var selection = FamilyActivitySelection()
    
    @State var isPresented = false
    var tokens: [ApplicationToken] {
        didSet {
            print("GGG!")
        }
    }
    
    init() {
        self.tokens = Array(ScreenTimeVM.shared.selectionToDiscourage.applicationTokens)
        print(ScreenTimeVM.shared.selectionToDiscourage)
    }
    
    let columns = [
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56)),
        GridItem(.fixed(56))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 24.0)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("계획한 수면 시간을 설정해주세요").font(.largeTitle.bold())
                    Text("7시간 이상의 숙면은 내일의 집중을 도와줍니다.").foregroundColor(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 24.0)
                
                // TODO::Pick interface
                
                // VERSION 1
                HStack(spacing: 0) {
                    Text("제한 중인 앱 목록").font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    Button("편집") { isPresented = true }
                        .familyActivityPicker(isPresented: $isPresented,
                                              selection: $selection).font(.subheadline).padding(.horizontal, 10.0).padding(.vertical, 4.0)
                        .background(.white)
                        .border(.white, width: 0)
                        .cornerRadius(16)
                }
                
                
                Spacer().frame(height: 8.0)
                
                // 앱 아이콘 나오는 부분
                
                if (selection.applicationTokens.count > 0 || selection.categoryTokens.count > 0) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 18){
                        if selection.applicationTokens.count > 0 {
                            ForEach(Array(selection.applicationTokens), id: \.self) {
                                token in
                                HStack {
                                    Label(token)
                                        .labelStyle(.iconOnly)
                                        .scaleEffect(3)
                                }
                                .frame(width: 56, height: 56)
                            }
                        }
                        if selection.categoryTokens.count > 0 {
                            ForEach(Array(selection.categoryTokens), id: \.self) {
                                token in
                                HStack {
                                    Label(token)
                                        .labelStyle(.iconOnly)
                                        .scaleEffect(2.0)
                                }
                                .frame(width: 56, height: 56)
                            }
                        }
                    }
                    .padding(CGFloat.spacing16)
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .background(Color.primary3)
                    .cornerRadius(16)
                }
                else {
                    Text("선택된 앱이 없습니다.").foregroundColor(Color.systemGray)
                        .padding(CGFloat.spacing16)
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.primary3)
                        .cornerRadius(16)
                }
                
                
            }.padding(.horizontal, 24)
            
            Spacer()
            
            NavigationLink(destination: {
                MainView()
            }) {
                Text("시작하기").foregroundColor(.white)
            }.padding().frame(maxWidth: .infinity)
                .foregroundColor(.systemWhite)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding([.horizontal, .bottom], CGFloat.spacing24)
        }.simultaneousGesture(TapGesture().onEnded{
            // MARK: 선택한 제한 앱 @AppStorage 변수에 저장
            ScreenTimeVM.shared.selectionToDiscourage = selection
            // MARK: 수면 계획 모니터링 시작
            ScreenTimeVM.shared.handleStartDeviceActivityMonitoring(
                startTime: ScreenTimeVM.shared.sleepStartDateComponent,
                endTime: ScreenTimeVM.shared.sleepEndDateComponent,
                deviceActivityName: .dailySleep
            )
        }).padding().navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("수면계획 설정").font(.headline)
                    }
                }
            }
            .background(Color.systemGray6, ignoresSafeAreaEdges: .all)
            .onChange(of: selection) {
                authStatus in
                print("ggg")
                
            }
    }
}
