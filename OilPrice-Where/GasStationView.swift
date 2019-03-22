//
//  GasStationView.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 14..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit
import SCLAlertView

// 메인페이지의 리스트의 셀 내부(ContentView)에 표시되는 뷰
// 스택뷰는 기본적으로 숨겨져 있으며 클릭시 스택뷰가 나타난다.
class GasStationView: UIView {
   
   // 기본 설정 관련
   @IBOutlet private weak var name : UILabel! // 주유소 명
   @IBOutlet private weak var price : UILabel! // 기름 가격
   @IBOutlet private weak var distance : UILabel! // 거리
   @IBOutlet private weak var oilType : UILabel! // 기름 타입
   @IBOutlet private weak var logo : UIImageView! // 로고(SK, GS, 알뜰 등..)
   var id: String?
   
   // Stack View
   @IBOutlet weak var stackView : UIStackView! // 내부 버튼(즐겨찾기, 경로 표시)을 가진 뷰(isHidden = true)
   @IBOutlet weak var favoriteButton : UIButton! // 즐겨 찾기 버튼
   @IBOutlet weak var annotationButtonView : UIView! // 경로 표시 버튼
   
   // 뷰 내부 설정
   func configure(with gasStation: GasStation) {
      let distanceKM = gasStation.distance / 1000 // m -> km 거리 계산
      
      self.id = gasStation.id // 주유소 ID 값 설정
      self.name.text = gasStation.name // 주유소 명 설정
      self.distance.text = String(distanceKM.roundTo(places: 2)) + "km" // 거리 설정
      self.logo.image = Preferences.logoImage(logoName: gasStation.brand) // 로고 이미지 삽입
      self.oilType.text = Preferences.oil(code: DefaultData.shared.oilType) // 오일 타입 설정
      self.price.text = Preferences.priceToWon(price: gasStation.price) // 기름 가격 설정
      
      // annotationButtonView 외곽선 설정
      annotationButtonView.layer.cornerRadius = 6
      annotationButtonView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
      annotationButtonView.layer.borderWidth = 1.5
      
      // favoriteButton 외곽선 설정
      favoriteButton.layer.borderColor = UIColor(named: "MainColor")!.cgColor // 즐겨찾기 버튼 외곽선 컬러
      favoriteButton.layer.borderWidth = 1.5 // 즐겨찾기 버튼 외곽선 크기
      favoriteButton.layer.cornerRadius = 6 // 즐겨찾기 버튼 외곽선 Radius 값 설정
      
      // favoriteButton 기본 이미지 및 선택 이미지 설정
      favoriteButton.setImage(UIImage(named: "favoriteOffIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
      favoriteButton.setImage(UIImage(named: "favoriteOnIcon")?.withRenderingMode(.alwaysTemplate), for: .selected)
      
      // favoriteButton Action 설정
      favoriteButton.addTarget(self, action: #selector(self.clickedEvent(_:)), for: .touchUpInside)
      
      self.favoriteButton.backgroundColor = UIColor.white // 즐겨찾기 버튼의 기본 배경색
      favoriteButton.imageView!.tintColor = UIColor(named: "MainColor") // 즐겨찾기 버튼 이미지 컬러
      favoriteButton.isSelected = false
      
      // 즐겨찾기 목록의 StationID 값과 StationView의 StationID값이 동일 하면 선택 상태로 변경
      for index in 0 ..< DefaultData.shared.favoriteArr.count {
         if self.id == DefaultData.shared.favoriteArr[index] {
            self.favoriteButton.isSelected = true
            self.favoriteButton.backgroundColor = UIColor(named: "MainColor")
            favoriteButton.imageView!.tintColor = UIColor.white
            break
         }
      }
   }
   
   // MainList Selected Frame
   func favoriteButtonUpdateFrame() {
      // 즐겨찾기 목록의 StationID 값과 StationView의 StationID값이 동일 하면 선택 상태로 변경
      for index in 0..<DefaultData.shared.favoriteArr.count {
         if self.id == DefaultData.shared.favoriteArr[index] {
            self.favoriteButton.isSelected = true
            self.favoriteButton.backgroundColor = UIColor(named: "MainColor")
            favoriteButton.imageView!.tintColor = UIColor.white
            break
         }
      }
      // favoriteButton.isSelected가 false일 시 초기상태로 변경
      if !self.favoriteButton.isSelected {
         self.favoriteButton.backgroundColor = UIColor.white
         favoriteButton.imageView!.tintColor = UIColor(named: "MainColor")
      }
   }
   
   // Favorite Button Clicked Event
   @objc func clickedEvent(_ sender: UIButton) {
      guard DefaultData.shared.favoriteArr.count < 3 else { // 즐겨 찾기의 수가 3개 이하 일 경우 실행
         if sender.isSelected { // 3개 이상일 때 isSelect 상태 true 일 시 즐겨찾기 상태를 해제
            favoriteButton.imageView!.tintColor = UIColor(named: "MainColor")
            favoriteButton.backgroundColor = UIColor.white
            DefaultData.shared.favoriteArr = DefaultData.shared.favoriteArr.filter { $0 != self.id }
            DefaultData.shared.saveFavorite()
            sender.isSelected = false
         } else {
            let appearance = SCLAlertView.SCLAppearance(
               kWindowWidth: 300,
               kTitleFont: UIFont(name: "NanumSquareRoundB", size: 18)!,
               kTextFont: UIFont(name: "NanumSquareRoundR", size: 15)!,
               showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            alert.iconTintColor = UIColor.white
            let timeOut = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: 1.5, timeoutAction: {})
            
            alert.showWarning("최대 3개까지 추가 가능합니다", subTitle: "이전 즐겨찾기를 삭제하고 추가해주세요 !", timeout: timeOut, colorStyle: 0x5E82FF)
         }
         return
      }
      // 즐겨찾기 설정 및 해제
      if sender.isSelected { // 즐겨찾기 설정
         favoriteButton.imageView!.tintColor = UIColor(named: "MainColor")
         favoriteButton.backgroundColor = UIColor.white
         DefaultData.shared.favoriteArr = DefaultData.shared.favoriteArr.filter { $0 != self.id }
         DefaultData.shared.saveFavorite()
         sender.isSelected = false
      } else { // 즐겨찾기 해제
         DefaultData.shared.favoriteArr.append(self.id!)
         DefaultData.shared.saveFavorite()
         favoriteButton.imageView!.tintColor = UIColor.white
         favoriteButton.backgroundColor = UIColor(named: "MainColor")
         sender.isSelected = true
         DefaultData.shared.saveFavorite()
      }
   }
}
