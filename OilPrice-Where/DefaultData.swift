//
//  Station.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 8..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyPlistManager

// App 전체에서 사용하는 싱글톤
class DefaultData {
   static let shared = DefaultData() // 싱글톤 객체 생성
   private let bag = DisposeBag()
   var currentType: MapType?
   
   // 기본 설정
   private init() {
      setData()
      
      mapsSubject.subscribe(onNext: {
         self.currentType = MapType.map(type: $0)
      })
         .disposed(by: bag)
   }
   
   var stationsSubject = BehaviorSubject<[GasStation]>(value: []) // 반경 주유소 리스트
   var priceData: [AllPrice] = [] // 전국 평균 기름 값
   var mapsSubject = BehaviorSubject<String>(value: "AppleMap")
   var radiusSubject = BehaviorSubject<Int>(value: 3000) // 탐색 반경
   var oilSubject = BehaviorSubject<String>(value: "") // 오일 종류
   var brandsSubject = BehaviorSubject<[String]>(value: []) // 설정 브랜드
   var favoriteSubject = BehaviorSubject<[String]>(value: []) // 즐겨 찾기
   var naviSubject = BehaviorSubject<String>(value: "kakao")
   var salesSubject = BehaviorSubject<[String: Int]>(value: [:])
   var tempFavArr: [InformationGasStaion] = []
   
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
   
   func localSave(favorites: InformationGasStaions) {
//      UserDefaults.standard.removeObject(forKey: "LocalFavorites")
//      UserDefaults.standard.synchronize()
      
      let def = UserDefaults(suiteName: "group.wargi.oilPriceWhere")
//      def?.removeObject(forKey: "FavoriteArr")
//      def?.synchronize()
      
      if let encodeData = try? JSONEncoder().encode(favorites) {
         def?.set(encodeData, forKey: "FavoriteArr")
         def?.synchronize()
         
         UserDefaults.standard.set(encodeData, forKey: "LocalFavorites")
         UserDefaults.standard.synchronize()
      }
   }
   
   private func getValue<T>(defaultValue: T, for key: String, _ fromPlistWithName: String = "UserInfo") -> T {
      guard let v = SwiftyPlistManager.shared.fetchValue(for: key, fromPlistWithName: fromPlistWithName) as? T else {
         SwiftyPlistManager.shared.addNew(defaultValue, key: key,
                                          toPlistWithName: fromPlistWithName,
                                          completion: { _ in })
         
         return defaultValue
      }
      
      return v
   }
   
   func setData() {
      let defaultBrands = ["SKE", "GSC", "HDO", "SOL", "RTO", "RTX", "NHO", "ETC", "E1G", "SKG"]
      let defaultSales = [ "SK": 0, "HDO": 0, "GSC": 0, "SOL": 0, "E1G": 0, "RTO": 0, "NHO": 0]
      
      SwiftyPlistManager.shared.start(plistNames: ["UserInfo"], logging: true) // Plist 불러오기
      
      let map = getValue(defaultValue: "AppleMap", for: "MapType")
      let radius = getValue(defaultValue: 5000, for: "FindRadius")
      let oilType = getValue(defaultValue: "", for: "OilType")
      let brands = getValue(defaultValue: defaultBrands, for: "Brands")
      let favArr = getValue(defaultValue: [String](), for: "Favorites")
      let naviType = getValue(defaultValue: "kakao", for: "NaviType")
      let sales = getValue(defaultValue: defaultSales, for: "Sales")
      
      mapsSubject.onNext(map)
      oilSubject.onNext(oilType)
      radiusSubject.onNext(radius)
      favoriteSubject.onNext(favArr)
      brandsSubject.onNext(brands)
      naviSubject.onNext(naviType)
      salesSubject.onNext(sales)
      
      // Map Type Save
      mapsSubject
         .subscribe(onNext: {
            SwiftyPlistManager.shared.save($0,
                                           forKey: "MapType",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save Oil Type !!")
                                             }}
         })
         .disposed(by: bag)
      
      // Oil Type Save
      oilSubject
         .subscribe(onNext: {
            SwiftyPlistManager.shared.save($0,
                                           forKey: "OilType",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save Oil Type !!")
                                             }}
         })
         .disposed(by: bag)
      
      // Find Radius Value Save
      radiusSubject
         .subscribe(onNext: {
            SwiftyPlistManager.shared.save($0,
                                           forKey: "FindRadius",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save Distance !!")
                                             }}
         })
         .disposed(by: bag)
      
      // Favorites Array Save
      favoriteSubject
         .subscribe(onNext: { infomations in
            SwiftyPlistManager.shared.save(infomations,
                                           forKey: "Favorites",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save Favorites !!")
                                             }}
            
            var tempArr = [String]()
            self.tempFavArr = self.tempFavArr.compactMap { info in
               if !tempArr.contains(info.id) && infomations.contains(info.id) {
                  tempArr.append(info.id)
                  return info
               }
               return nil
            }
            
            var favorites = InformationGasStaions(allPriceList: self.tempFavArr)
            
            self.localSave(favorites: favorites)
            print(tempArr)
            for key in infomations {
               guard !tempArr.contains(key) else { continue }
               ServiceList.informationGasStaion(appKey: Preferences.getAppKey(),
                                                id: key) { (result) in
                  switch result {
                  case .success(let info):
                     print("#1")
                     tempArr.append(info.id)
                     self.tempFavArr.append(info)
                     favorites.allPriceList.append(info)
                     self.localSave(favorites: favorites)
                  case .error(let error):
                     print(error.localizedDescription)
                  }
               }
            }
            
            
         })
         .disposed(by: bag)
      
      // Brand Array Save
      brandsSubject
         .subscribe(onNext: {
            SwiftyPlistManager.shared.save($0,
                                           forKey: "Brands",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save BrandType !!")
                                             }}
         })
         .disposed(by: bag)
      
      // Navi Type Save
      naviSubject
         .subscribe(onNext: {
            SwiftyPlistManager.shared.save($0,
                                           forKey: "NaviType",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save BrandType !!")
                                             }}
         })
         .disposed(by: bag)
      
      // Sales Save
      salesSubject
         .subscribe(onNext: {
            SwiftyPlistManager.shared.save($0,
                                           forKey: "Sales",
                                           toPlistWithName: "UserInfo") { (err) in
                                             if err != nil {
                                                print("Success Save BrandType !!")
                                             }}
         })
         .disposed(by: bag)
   }
}
