//
//  Service.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 25..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Alamofire

protocol ServiceType {
   static func gasStationList(x: Double, y: Double, radius: Int, prodcd: String, sort: Int, appKey: String, completion: @escaping (Result<OilList>) -> ())
   static func allPriceList(appKey: String, completion: @escaping (Result<AllPriceResult>) -> ())
   static func informationGasStaion(appKey: String, id: String, completion: @escaping (Result<InformationOilStationResult>) -> ())
   
}

struct ServiceList: ServiceType {
   static func informationGasStaion(appKey: String, id: String, completion: @escaping (Result<InformationOilStationResult>) -> ()) {
      Alamofire
         .request(API.detailById(appKey: appKey, id: id).urlString)
         .validate()
         .responseData { (response) in
            switch response.result {
            case .success(let value):
               do {
                  var dataToString = String(data: value, encoding: String.Encoding.utf8)
                  dataToString = Preferences.stringByRemovingControlCharacters2(string: dataToString!)
                  let nData = dataToString?.data(using: String.Encoding.utf8)
                  let stationInfo = try nData!.decode(InformationOilStationResult.self)
                  completion(.success(stationInfo))
               } catch {
                  completion(.error(error))
                  
               }
            case .failure(let err):
               completion(.error(err))
               
            }
      }
   }
   
   static func allPriceList(appKey: String, completion: @escaping (Result<AllPriceResult>) -> ()) {
      Alamofire
         .request(API.avgAll(appKey: appKey).urlString)
         .validate()
         .responseData { (response) in
            switch response.result {
            case .success(let value):
               do {
                  let priceData = try value.decode(AllPriceResult.self)
                  completion(.success(priceData))
               } catch {
                  completion(.error(error))
               }
            case .failure(let err):
               completion(.error(err))
            }
      }
   }
   
   static func gasStationList(x: Double, y: Double, radius: Int, prodcd: String, sort: Int, appKey: String, completion: @escaping (Result<OilList>) -> ()) {
      Alamofire
         .request(API.aroundAll(x: x, y: y, radius: radius, prodcd: prodcd, sort: sort, appKey: appKey).urlString)
         .validate()
         .responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
               do {
                  let restaurantData = try value.decode(OilList.self)
                  completion(.success(restaurantData))
               } catch {
                  completion(.error(error))
               }
            case .failure(let error):
               completion(.error(error))
            }
         })
   }
   
   static func nationCostAverage(appKey: String, completion: @escaping (Result<NationCostList>) -> ()) {
      Alamofire
         .request(API.avgAll(appKey: appKey).urlString)
         .validate()
         .responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
               do {
                  let nationCostList = try value.decode(NationCostList.self)
                  print(nationCostList)
                  completion(.success(nationCostList))
               } catch {
                  completion(.error(error))
               }
            case .failure(let error):
               completion(.error(error))
            }
         })
   }
}
