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
    
    @State var selection = FamilyActivitySelection() {
        didSet {
            ScreenTimeVM.shared.selectionToDiscourage = selection
        }
    }
    
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
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("사용을 제한할 앱을 선택해주세요").font(.largeTitle.bold())
                Text("7시간 이상의 숙면은 내일의 집중을 도와줍니다.").foregroundColor(.gray)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            // TODO::Pick interface
            
            // VERSION 1
            HStack {
                Text("제한 중인 앱 목록").font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button("편집") { isPresented = true }
                    .familyActivityPicker(isPresented: $isPresented,
                  selection: $selection)
            }
            
            Spacer().frame(height: 8.0)
            
            // 앱 아이콘 나오는 부분
            
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
                        .border(.blue)
                    }
                    .border(.red)
                }
            }
            .padding(CGFloat.spacing16)
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color.primary3)
            .cornerRadius(16)
            Spacer()
            NavigationLink(destination: {
                MainView()
            }) {
                Text("시작하기").foregroundColor(.white)
            }.padding()
                .frame(width: 240)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding().navigationBarTitleDisplayMode(.inline)
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
