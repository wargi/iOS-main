//
//  InformationGasStaion.swift
//  OilPrice-Where
//
//  Created by Himchan Park on 2018. 8. 17..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation

struct InformationOilStationResult: Decodable {
   let result: InformationGasStaions
   
   private enum CodingKeys: String, CodingKey {
      case result = "RESULT"
   }
}

struct InformationGasStaions: Decodable {
   let allPriceList: [InformationGasStaion]
   
   private enum CodingKeys: String, CodingKey {
      case allPriceList = "OIL"
   }
}


struct InformationGasStaion: Decodable {
   let id: String
   let brand: String
   //     브랜드(SKE:SK에너지, GSC:GS칼텍스, HDO:현대오일뱅크, SOL:S-OIL, RTO:자영알뜰,
   //          RTX:고속도로알뜰, NHO:농협알뜰, ETC:자가상표, E1G: E1, SKG:SK가스
   let name: String // 매장 이름
   let address: String // 주소
   let phoneNumber: String // 전화번호
   let qualityCertification: String //품질인증여부
   let repairShop: String // 카센터
   let convenienceStore: String // 편의점
   let carWash: String // 세차장
   let price: [Price]
   let katecX: Double
   let katecY: Double
   
   private enum CodingKeys: String, CodingKey {
      case id = "UNI_ID"
      case brand = "POLL_DIV_CO"
      case name = "OS_NM"
      case address = "VAN_ADR"
      case phoneNumber = "TEL"
      case qualityCertification = "KPETRO_YN"
      case repairShop = "MAINT_YN"
      case convenienceStore = "CVS_YN"
      case carWash = "CAR_WASH_YN"
      case price = "OIL_PRICE"
      case katecX = "GIS_X_COOR"
      case katecY = "GIS_Y_COOR"
   }
}

struct Price: Decodable {
   let type: String
   let price: Int
   
   private enum CodingKeys: String, CodingKey {
      case type = "PRODCD"
      case price = "PRICE"
   }
}
