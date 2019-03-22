//
//  Station.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 8..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation
import SwiftyPlistManager

// App 전체에서 사용하는 싱글톤
class DefaultData {
   static let shared = DefaultData() // 싱글톤 객체 생성
   // 기본 설정
   private init() {
      SwiftyPlistManager.shared.start(plistNames: ["UserInfo"], logging: true) // Plist 불러오기
      
      self.data = nil // 주유소 리스트 데이터 초기화
      self.radius = SwiftyPlistManager.shared.fetchValue(for: "FindRadius", // 탐색 반경 설정
         fromPlistWithName: "UserInfo") as! Int
      self.oilType = SwiftyPlistManager.shared.fetchValue(for: "OilType", // 탐색 오일 설정
         fromPlistWithName: "UserInfo") as! String
      if let brandName = SwiftyPlistManager.shared.fetchValue(for: "BrandType", fromPlistWithName: "UserInfo") as? String {
         self.brandType = brandName
      } else {
         SwiftyPlistManager.shared.addNew("ALL", key: "BrandType", toPlistWithName: "UserInfo", completion: { (err) in
            if err != nil {
               self.brandType = "ALL"
               print("Success")
            }
         })
      }
      self.favoriteArr = SwiftyPlistManager.shared.fetchValue(for: "Favorites", fromPlistWithName: "UserInfo") as! [String]
      
   }
   var data: [GasStation]? // 반경 주유소 리스트
   var priceData: [AllPrice] = [] // 전국 평균 기름 값
   var radius = 3000 // 탐색 반경
   var oilType = "" // 오일 종류
   var brandType = "" // 설정 브랜드
   var favoriteArr: [String] = [] // 즐겨 찾기
   
   // Plist에 값 저장
   func saveOil() {
      // Oil Type Save
      SwiftyPlistManager.shared.save(DefaultData.shared.oilType,
                                     forKey: "OilType",
                                     toPlistWithName: "UserInfo") { (err) in
                                       if err != nil {
                                          print("Success Save Oil Type !!")
                                       }
      }
   }
   
   func saveDistance() {
      // Find Radius Value Save
      SwiftyPlistManager.shared.save(DefaultData.shared.radius,
                                     forKey: "FindRadius",
                                     toPlistWithName: "UserInfo") { (err) in
                                       if err != nil {
                                          print("Success Save Distance !!")
                                       }
      }
   }
   
   func saveFavorite() {
      // Favorites Array Save
      SwiftyPlistManager.shared.save(DefaultData.shared.favoriteArr,
                                     forKey: "Favorites",
                                     toPlistWithName: "UserInfo") { (err) in
                                       if err != nil {
                                          print("Success Save Favorites !!")
                                       }
      }
   }
   
   func saveBrand() {
      // Brand Array Save
      SwiftyPlistManager.shared.save(DefaultData.shared.brandType,
                                     forKey: "BrandType",
                                     toPlistWithName: "UserInfo") { (err) in
                                       if err != nil {
                                          print("Success Save BrandType !!")
                                       }
      }
   }
   
   // 전군 평균 기름 값 로드 함수
   func allPriceDataLoad() {
      ServiceList.allPriceList(appKey: Preferences.getAppKey()) { (result) in
         switch result {
         case .success(let allPriceListData):
            self.priceData = allPriceListData.result.allPriceList
         case .error(let err):
            print(err)
         }
      }
   }
}
