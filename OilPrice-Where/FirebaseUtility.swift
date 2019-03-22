//
//  FirebaseUtility.swift
//  OilPrice-Where
//
//  Created by SolChan Ahn on 2018. 8. 14..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUtility {
   
   var ref: DatabaseReference!
   
   func getAverageCost(productName: String, completion: @escaping (NSDictionary) -> ()) {
      
      ref = Database.database().reference()
      
      let data = ref.child("systemData").child("averageCostList").child(productName)
      
      data.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
         do {
            let priceData = try snapshot.value as! NSDictionary
            completion(priceData)
         } catch {
            completion(["error":"nil Data"])
         }
      })
   }
   
   func checkUpdateTime(){
      let date = Date()
      let formatter = DateFormatter()
      
      formatter.dateFormat = "yyyyMMdd"
      let curruntTime = formatter.string(from: date)
      
      ref = Database.database().reference()
      
      let data = ref.child("systemData").child("averageCostList").child("updateTime")
      
      data.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
         let updateTime = snapshot.value as? String ?? ""
         
         if curruntTime != updateTime {
            ServiceList.allPriceList(appKey: Preferences.getAppKey()) { (result) in
               switch result {
               case .success(let allPriceListData):
                  let priceDatas = allPriceListData.result.allPriceList
                  
                  for data in priceDatas {
                     var productName = ""
                     switch data.oilCode {
                     case "D047":
                        productName = "dieselCost"
                     case "B027":
                        productName = "gasolinCost"
                     case "K015":
                        productName = "lpgCost"
                     case "B034":
                        productName = "premiumCost"
                     default: break
                     }
                     
                     let tempPrice = data.price.components(separatedBy: ".")[0]
                     var price = ""
                     
                     if tempPrice.count > 3 {
                        price = tempPrice.substring(to: tempPrice.index(tempPrice.endIndex, offsetBy: -3)) + "," + tempPrice.substring(from: tempPrice.index(tempPrice.endIndex, offsetBy: -3))
                     } else {
                        price = tempPrice
                     }
                     var difference = true
                     if data.diff.substring(to: data.diff.index(after: data.diff.startIndex)) == "-" {
                        difference = false
                     }else {
                        difference = true
                     }
                     
                     let updateCostData = ["difference": difference,
                                           "price": price] as [String : Any]
                     
                     if productName != "" {
                        self.ref.child("systemData").child("averageCostList").child(productName).updateChildValues(updateCostData)
                     }
                     
                  }
                  self.ref.child("systemData").child("averageCostList").updateChildValues(["updateTime": priceDatas[0].tradeDate])
               case .error(let err):
                  print(err)
               }
            }
         }
      })
   }
}
