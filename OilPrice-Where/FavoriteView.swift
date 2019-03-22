//
//  FavoriteView.swift
//  favorite
//
//  Created by 박상욱 on 2018. 8. 25..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

class FavoriteView: UIView {
   
   // Xib view 연결
   @IBOutlet weak var mainView: UIView!
   
   // 이미지
   @IBOutlet weak var logoImageView: UIImageView!
   @IBOutlet weak var carWashImageView: UIImageView!
   @IBOutlet weak var repairShopImageView: UIImageView!
   @IBOutlet weak var convenienceStoreImageView: UIImageView!
   @IBOutlet weak var naviImageView: UIImageView!
   
   // 레이블
   @IBOutlet weak var gasStationNameLabel: UILabel!
   @IBOutlet weak var addressLabel: UILabel!
   @IBOutlet weak var phoneNumberLabel: UILabel!
   @IBOutlet weak var qualityCertificationLabel: UILabel!
   @IBOutlet weak var typeOfOilLabel: UILabel!
   @IBOutlet weak var oilPlice: UILabel!
   @IBOutlet var containerView: UIView!
   @IBOutlet var navigationView: UIView!
   @IBOutlet var navigationLabel: UILabel!
   @IBOutlet var deleteFavoriteButton: UIButton!
   
   var tapGesture = UITapGestureRecognizer()
   var id: String!
   
   // KatecX, KatecY
   var katecX: Double?
   var katecY: Double?    
   
   func configure(with informaionGasStaion: InformationGasStaion) {
      
      self.id = informaionGasStaion.id
      mainView.layer.cornerRadius = 6
      
      var count = 0
      self.katecX = informaionGasStaion.katecX.roundTo(places: 0)
      self.katecY = informaionGasStaion.katecY.roundTo(places: 0)
      
      self.gasStationNameLabel.text = informaionGasStaion.name // 주유소 이름
      self.gasStationNameLabel.font = UIFont(name: "NanumSquareRoundB", size: 26)
      self.addressLabel.text = informaionGasStaion.address // 주소
      self.phoneNumberLabel.text = informaionGasStaion.phoneNumber // 전화번호
      self.navigationLabel.font = UIFont(name: "NanumSquareRoundB", size: 18)
      self.navigationLabel.textAlignment = .center
      
      self.deleteFavoriteButton.layer.cornerRadius = 6
      self.deleteFavoriteButton.layer.borderColor = UIColor(named: "MainColor")?.cgColor
      self.deleteFavoriteButton.layer.borderWidth = 1.5
      self.deleteFavoriteButton.setImage(UIImage(named: "favoriteOnIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
      self.deleteFavoriteButton.imageView?.tintColor = .white
      
      self.navigationView.layer.cornerRadius = 6
      self.navigationView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
      self.navigationView.layer.borderWidth = 1.5
      tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigationButton))
      navigationView.addGestureRecognizer(tapGesture)
      
      self.carWashImageView.image = UIImage(named: "IconWash")?.withRenderingMode(.alwaysTemplate)
      self.repairShopImageView.image = UIImage(named: "IconRepair")?.withRenderingMode(.alwaysTemplate)
      self.convenienceStoreImageView.image = UIImage(named: "IconConvenience")?.withRenderingMode(.alwaysTemplate)
      
      // 세차장 여부
      if informaionGasStaion.carWash == "Y" {
         self.carWashImageView.tintColor = UIColor(named: "MainColor")
      } else {
         self.carWashImageView.tintColor = UIColor.lightGray
      }
      
      // 카센터 여부
      if informaionGasStaion.repairShop == "Y" {
         self.repairShopImageView.tintColor = UIColor(named: "MainColor")
      } else {
         self.repairShopImageView.tintColor = UIColor.lightGray
      }
      
      // 편의점 여부
      if informaionGasStaion.convenienceStore == "Y" {
         self.convenienceStoreImageView.tintColor = UIColor(named: "MainColor")
      } else {
         self.convenienceStoreImageView.tintColor = UIColor.lightGray
      }
      
      // 품질인증확인
      if informaionGasStaion.qualityCertification == "Y" {
         self.qualityCertificationLabel.text = "인증"
      } else {
         self.qualityCertificationLabel.text = "미인증"
      }
      
      self.logoImageView.image = Preferences.logoImage(logoName: informaionGasStaion.brand) // 로고 이미지 삽입
      for index in 0 ..< informaionGasStaion.price.count {
         if informaionGasStaion.price[index].type == DefaultData.shared.oilType {
            self.typeOfOilLabel.text = Preferences.oil(code: DefaultData.shared.oilType) // 오일 타입 설정
            self.oilPlice.text = Preferences.priceToWon(price: informaionGasStaion.price[index].price) // 가격 설정
            self.oilPlice.font = UIFont(name: "NanumSquareRoundEB", size: 43)
            count += 100
         }
         count += 1
      }
      if informaionGasStaion.price.count == count {
         self.typeOfOilLabel.text = Preferences.oil(code: informaionGasStaion.price[0].type) // 오일 타입 설정
         self.oilPlice.text = Preferences.priceToWon(price: informaionGasStaion.price[0].price) // 가격 설정
         self.oilPlice.font = UIFont(name: "NanumSquareRoundEB", size: 43)
      }
   }
   
   // 길 안내
   @objc func navigationButton(_ sender: UIButton) {
      guard let katecX = self.katecX,
         let katecY = self.katecY,
         let name = gasStationNameLabel.text else { return }
      let destination = KNVLocation(name: name,
                                    x: NSNumber(value: katecX),
                                    y: NSNumber(value: katecY))
      let options = KNVOptions()
      
      let params = KNVParams(destination: destination,
                             options: options)
      KNVNaviLauncher.shared().navigate(with: params)
   }
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      commitInit()
   }
   
   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
      commitInit()
   }
   
   private func commitInit() {
      Bundle.main.loadNibNamed("FavoriteView", owner: self, options: nil)
      addSubview(containerView)
      containerView.frame = self.bounds
      containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
   }
}
