//
//  MainVM.swift
//  sunghoyazaza
//
//  Created by 077tech on 2023/05/07.
//
//MARK: 메인 VM

import Foundation
struct MainVM{
    
    //MARK: 메인 문구 바꿔주기
    func changeMainText()->Int{
        var indexNumber : Int
        
        if DateVM().findConsecutiveDays() == 0{
            indexNumber = 0
        } else{
            indexNumber = 1
        }
        return indexNumber
    }
    
    //MARK: 서브 문구 생성을 위한 랜덤 숫자 생성기
    func makeRandomNumber()->Int{
        if changeMainText() == 0{
            return 0
        }else{
            return Int.random(in: 1...MainModel().subLabel.count-1)
        }
    }
    
    //MARK: 차단된 어플리케이션 개수 함수
    func blockApplicationCount()->Int{
        return MainModel().blockApplicationData.count
    }
    
    
}



