//
//  Converter.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 8..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation
import GoogleMaps
import SCLAlertView
import CoreLocation

// 카텍 좌표 저장
struct KatecPoint {
   let x: Double
   let y: Double
}

// 위치 변환
final class Converter {
   static func centerCoordinates(with googleMaps: GMSMapView) -> CLLocationCoordinate2D {
      let latitude = googleMaps.projection.coordinate(for: googleMaps.center).latitude
      let longitude = googleMaps.projection.coordinate(for: googleMaps.center).longitude
      
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
   }
   
   // 위치 변환 ( WGS84 -> Katec )
   static func convertWGS84ToKatec(coordinate: CLLocationCoordinate2D) -> KatecPoint {
      let convert = GeoConverter()
      let wgsPoint = GeographicPoint(x: coordinate.longitude, y: coordinate.latitude)
      let tmPoint = convert.convert(sourceType: .WGS_84, destinationType: .TM, geoPoint: wgsPoint)
      let katecPoint = convert.convert(sourceType: .TM, destinationType: .KATEC, geoPoint: tmPoint!)
      
      return KatecPoint(x: katecPoint!.x, y: katecPoint!.y)
   }
   
   // 위치 변환 ( Katec -> WGS84 )
   static func convertKatecToWGS(katec: KatecPoint) -> CLLocationCoordinate2D {
      let convert = GeoConverter()
      let katecPoint = GeographicPoint(x: katec.x, y: katec.y)
      let wgsPoint = convert.convert(sourceType: .KATEC,
                                     destinationType: .WGS_84,
                                     geoPoint: katecPoint)
      
      return CLLocationCoordinate2D(latitude: wgsPoint!.y,
                                    longitude: wgsPoint!.x)
      
   }
}

// App 기본 설정
final class Preferences {
   // initialViewController 초기 설정 페이지 관련 함수
   // 처음 앱을 켰을 때 저장 되어있는 오일 타입이 설정 되어 있지 않을 시에
   // 초기 설정 페이지(InitialSettingViewController)를 루트 뷰로 설정
   // 오일 타입이 있다면 메인 리스트 페이지(TabBarController)를 루트뷰로 설정

   
   static func notConnect() {
      // Alert 설정
      let appearance = SCLAlertView.SCLAppearance(
         kWindowWidth: 300, // Alert Width
         kTitleFont: UIFont(name: "NanumSquareRoundB", size: 18)!, // Alert Title Font
         kTextFont: UIFont(name: "NanumSquareRoundR", size: 15)!, // Alert Content Font
         showCloseButton: true // CloseButton isHidden = True
      )
      
      let alert = SCLAlertView(appearance: appearance)
      alert.showError("네트워크 오류 발생", subTitle: "인터넷 연결이 오프라인 상태입니다.", closeButtonTitle: "확인", colorStyle: 0x5E82FF)
      alert.iconTintColor = UIColor.white
   }
   
   // Random App Key
   // 5개의 App Key중 랜덤하게 한 개의 App Key 반환
   static func getAppKey() -> String {
      var appKey = ""
      
      switch Int.random(in: 0 ... 5) {
      case 0:
         appKey = "F302180619"
      case 1:
         appKey = "F303180619"
      case 2:
         appKey = "F304180619"
      case 3:
         appKey = "F305180619"
      case 4:
         appKey = "F306180619"
      default:
         appKey = "F307180619"
      }
      return appKey
   }
   
   // 받아오는 Logo Code값을 Image로 변환해주는 함수
   // ex) SKE -> UIImage(named: "LogoSKEnergy") // SK 로고이미지
   static func logoImage(logoName name: String?) -> UIImage? {
      guard let logoName = name else { return nil }
      switch logoName {
      case "SKE":
         return UIImage(named: "LogoSKEnergy")
      case "GSC":
         return UIImage(named: "LogoGSCaltex")
      case "HDO":
         return UIImage(named: "LogoOilBank")
      case "SOL":
         return UIImage(named: "LogoSOil")
      case "RTO":
         return UIImage(named: "LogoFrugalOil")
      case "RTX":
         return UIImage(named: "LogoExpresswayOil")
      case "NHO":
         return UIImage(named: "LogoNHOil")
      case "ETC":
         return UIImage(named: "LogoPersonalOil")
      case "E1G":
         return UIImage(named: "LogoEnergyOne")
      case "SKG":
         return UIImage(named: "LogoSKGas")
      default:
         return nil
      }
   }
   
   // Oil Type을 Oil Code로 변환 함수
   // ex) 휘발유 -> B027
   static func oil(name: String) -> String {
      switch name {
      case "휘발유":
         return "B027"
      case "고급휘발유":
         return "B034"
      case "경유":
         return "D047"
      case "LPG":
         return "K015"
      default:
         return ""
      }
   }
   
   // Oil Code를 Oil Type으로 변환 함수
   // ex) B027 -> 휘발유
   static func oil(code: String) -> String {
      switch code {
      case "B027":
         return "휘발유"
      case "B034":
         return "고급휘발유"
      case "D047":
         return "경유"
      case "K015":
         return "LPG"
      default:
         return ""
      }
   }
   
   // Brand Type을 Brand Code로 변환 함수
   // ex) SK에너지 -> SKE
   
   static func brand(name: String) -> String {
      switch name {
      case "SK에너지":
         return "SKE"
      case "GS칼텍스":
         return "GSC"
      case "현대오일뱅크":
         return "HDO"
      case "S-OIL":
         return "SOL"
      case "자영알뜰":
         return "RTO"
      case "고속도로알뜰":
         return "RTX"
      case "농협알뜰":
         return "NHO"
      case "자가상표":
         return "ETC"
      case "E1":
         return "E1G"
      case "SK가스":
         return "SKG"
      default:
         return "ALL"
      }
   }
   
   // Brand Code를 Brand Type으로 변환 함수
   // ex) B027 -> 휘발유
   static func brand(code: String) -> String {
      switch code {
      case "SKE":
         return "SK에너지"
      case "GSC":
         return "GS칼텍스"
      case "HDO":
         return "현대오일뱅크"
      case "SOL":
         return "S-OIL"
      case "RTO":
         return "자영알뜰"
      case "RTX":
         return "고속도로알뜰"
      case "NHO":
         return "농협알뜰"
      case "ETC":
         return "자가상표"
      case "E1G":
         return "E1"
      case "SKG":
         return "SK가스"
      default:
         return "전체"
      }
   }
   
   static func saleBrand(name: String) -> String {
      switch name {
      case "GS칼텍스":
         return "GSC"
      case "현대오일뱅크":
         return "HDO"
      case "S-OIL":
         return "SOL"
      case "알뜰주유소":
         return "RTO"
      case "농협":
         return "NHO"
      case "E1":
         return "E1G"
      default:
         return "SK"
      }
   }
   
   static func saleBrand(code: String) -> Int {
      guard let sales = try? DefaultData.shared.salesSubject.value() else { return 0 }
      var value: Int?
      switch code {
      case "GSC":
         value = sales["GSC"]
      case "HDO":
         value = sales["HDO"]
      case "SOL":
         value = sales["SOL"]
      case "RTO":
         value = sales["RTO"]
      case "NHO":
         value = sales["NHO"]
      case "E1G":
         value = sales["E1G"]
      case "SKG", "SKE":
         value = sales["SK"]
      default:
         break
      }
      
      return value ?? 0
   }
   
   // String으로 표시 된 거리를 Int값으로 반환
   // ex) 1KM -> 1000
   static func distanceKM(KM: String) -> Int {
      switch KM {
      case "1KM":
         return 1000
      case "3KM":
         return 3000
      default: // 5KM
         return 5000
      }
   }
   
   // Map Type
   static func mapsType(name: String) -> String {
      switch name {
      case "Apple Map":
         return "AppleMap"
      default:
         return "GoogleMap"
      }
   }
   
   static func mapsType(code: String) -> String {
      switch code {
      case "AppleMap":
         return "Apple Map"
      default:
         return "Google Map"
      }
   }
   
   // 네비게이션 타입
   static func navigationType(name: String) -> String {
      switch name {
      case "카카오내비":
         return "kakao"
      case "kakao":
         return "카카오내비"
      case "tmap":
         return "T map"
      default:
         return "tmap"
      }
   }
   
   // Int값을 원화 사이의 ','를 넣어주는 함수
   static func priceToWon(price: Int) -> String {
      var stringPrice = ""
      
      if price >= 1000 {
         if (price % 1000) < 100 {
            stringPrice = String(price / 1000) + ",0" + String(price % 1000) + "원"
         } else {
            stringPrice = String(price / 1000) + "," + String(price % 1000) + "원"
         }
      } else {
         stringPrice = String(price) + "원"
      }
      
      return stringPrice
   }
   
   static func stringByRemovingControlCharacters2(string: String) -> String {
      let controlChars = NSCharacterSet.controlCharacters
      var range = string.rangeOfCharacter(from: controlChars)
      var mutable = string
      while let removeRange = range {
         mutable.removeSubrange(removeRange)
         range = mutable.rangeOfCharacter(from: controlChars)
      }
      return mutable
   }
}

// 반올림
extension Double {
   /// Rounds the double to decimal places value
   func roundTo(places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}

// 기종 확인
extension UIDevice {
   public var isiPhoneX: Bool {
      if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone &&
         (UIScreen.main.bounds.size.height > 736 || UIScreen.main.bounds.size.width > 414) {
         return true
      }
      return false
   }
}
