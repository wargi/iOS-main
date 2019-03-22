//
//  CustomAnnotationView.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 6..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation
import MapKit

// 어노테이션의 말풍선의 표시나, 어노테이션의 위치와
// 스테이션 정보를 가지고 있는 커스텀 어노테이션
class CustomMarkerAnnotation : NSObject, MKAnnotation {
   var coordinate: CLLocationCoordinate2D // 어노테이션의 위치
   var title: String? // 클릭시 뜨는 말풍선
   var subtitle: String? // 말풍선 내부의 subTitle
   var colour: UIColor? // 어노테이션 컬러
   var stationInfo: GasStation? // 어노테이션에 표시할 주유소 정보
   
   override init() {
      self.coordinate = CLLocationCoordinate2D()
      self.title = nil // title을 nil로 설정 (클릭 시 말풍선이 뜨지않는다.)
      self.subtitle = nil // subtitle을 nil로 설정 (클릭 시 subtitle이 뜨지않는다.)
      self.stationInfo = nil // 주유소 정보를 받기 전까지는 초기 값은 nil로 설정
      self.colour = UIColor.white // 기본 컬러
   }
}

// 지도에서 실질적으로 표시 되는 뷰
class CustomMarkerAnnotationView: MKAnnotationView {
   var mapMarkerImageView: UIImageView! // 지도에 표시되는 맵 마커 이미지 뷰
   private var logoImageView: UIImageView! // 맵 마커의 이미지 뷰 내부의 로고 이미지 뷰
   var priceLabel: UILabel! //맵 마커의 이미지 뷰 내부의 가격 표시 레이블
   var coordinate: CLLocationCoordinate2D? // 맵 마커의 위치
   var stationInfo: GasStation? // 마커 내부의 주유소 정보
   
   // 마커 기본 설정
   override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      
      // markerView 설정
      self.frame = CGRect(x: 0, y: 0, width: 65, height: 32)
      self.mapMarkerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 32))
      self.mapMarkerImageView.layer.masksToBounds = true
      self.addSubview(self.mapMarkerImageView)
      
      // logoImageView 설정
      self.logoImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 15, height: 15))
      self.addSubview(self.logoImageView)
      
      // priceLabel 설정
      self.priceLabel = UILabel(frame: CGRect(x: 22, y: 4, width: 37, height: 18))
      self.priceLabel.textAlignment = .left
      self.priceLabel.font = UIFont(name: "NanumSquareRoundEB", size: 13)
      self.addSubview(self.priceLabel)
   }
   
   // 로고 이미지 삽입
   override var image: UIImage? {
      get {
         return self.logoImageView.image
      }
      set {
         self.logoImageView.image = newValue
      }
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
