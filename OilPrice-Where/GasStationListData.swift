//
//  GasStationListData.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 25..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation

// 주유소 리스트를 받아오는 API Decodable
struct OilList: Decodable {
   let result: GasStations
   
   private enum CodingKeys: String, CodingKey {
      case result = "RESULT"
   }
}

struct GasStations: Decodable {
   let gasStations: [GasStation]
   
   private enum CodingKeys: String, CodingKey {
      case gasStations = "OIL"
   }
}

struct GasStation: Decodable {
   let id: String! // 주유소 코드
   // 브랜드(SKE:SK에너지, GSC:GS칼텍스, HDO:현대오일뱅크, SOL:S-OIL, RTO:자영알뜰,
   //      RTX:고속도로알뜰, NHO:농협알뜰, ETC:자가상표, E1G: E1, SKG:SK가스
   let brand: String
   let name: String // 매장 이름
   let price: Int // 가격
   let distance: Double // 기준 위치로부터의 거리 (단위 : m)
   let katecX: Double // X좌표(KATEC)
   let katecY: Double // Y좌표(KATEC)
   
   private enum CodingKeys: String, CodingKey {
      case id = "UNI_ID"
      case brand = "POLL_DIV_CD"
      case name = "OS_NM"
      case price = "PRICE"
      case distance = "DISTANCE"
      case katecX = "GIS_X_COOR"
      case katecY = "GIS_Y_COOR"
   }
}

extension GasStation: Equatable {
   public static func ==(lhs: GasStation, rhs: GasStation) -> Bool {
      return lhs.id == rhs.id
   }
}


