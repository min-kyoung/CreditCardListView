//
//  CreditCard.swift
//  CreditCardListView
//
//  Created by 노민경 on 2022/01/05.
//

import Foundation

// 읽을 때는 json decoding이 필요하고 쓸 때는 json encoding이 필요 => codable을 상속하는 객체를 만듦
struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool? // 사용자가 카드를 선택하기 전까지는 nil 값을 가짐
    
}

struct PromotionDetail: Codable {
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
