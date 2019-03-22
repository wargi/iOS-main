//
//  AllPriceData.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 15..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation

struct AllPriceResult: Decodable {
   let result: AllPriceOil
   
   private enum CodingKeys: String, CodingKey {
      case result = "RESULT"
   }
}

struct AllPriceOil: Decodable {
   let allPriceList: [AllPrice]
   
   private enum CodingKeys: String, CodingKey {
      case allPriceList = "OIL"
   }
}

struct AllPrice: Decodable {
   let tradeDate: String // 거래 일자
   let oilCode: String // 기름 코드
   let oilType: String // 기름 타입
   let price: String // 가격
   let diff: String // 저번주 평균가와 차이가
   
   private enum CodingKeys: String, CodingKey {
      case tradeDate = "TRADE_DT"
      case oilCode = "PRODCD"
      case oilType = "PRODNM"
      case price = "PRICE"
      case diff = "DIFF"
   }
}
