//
//  SleepPlanBottomView.swift
//  SungHozaza
//
//  Created by 077tech on 2023/05/07.
//


import SwiftUI

struct SleepPlanBottomView: View {
    var data: [String] = [
        "instagram",
        "youtube",
        "toss",
        "kakaotalk",
        "line",
        "discord",
        "facebook",
        "tiktok",
        "facebook",
        "tiktok",
        "facebook",
        "tiktok",
        "facebook",
        "tiktok"
    ]

    
    
    var body: some View {
        @State var dataCount = data.count
        
        VStack {
            HStack {
                if dataCount <= 7{
                    ForEach(0..<dataCount) { i in
                        Image(data[i])
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    Spacer()
                }else{
                    ForEach(0..<6) { i in
                        Image(data[i])
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    ZStack{
                        Image(data[6])
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                            .opacity(0.3)
                        Text("+\(dataCount-7)")
                            .bold()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: 0xF6F8FF))
        .cornerRadius(24)
    }
}

struct SleepPlanBottomView_Previews: PreviewProvider {
    static var previews: some View {
        SleepPlanBottomView()
    }
}

