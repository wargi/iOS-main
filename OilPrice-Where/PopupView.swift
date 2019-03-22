//
//  PopupView.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 01/02/2019.
//  Copyright © 2019 sangwook park. All rights reserved.
//

import UIKit

class PopupView: UIView {
   
   @IBOutlet private weak var minPriceLabel : UILabel!
   @IBOutlet private weak var avePriceLabel : UILabel!
   @IBOutlet private weak var radiusLabel : UILabel!
   @IBOutlet private weak var stationCountLabel : UILabel!
   
   func configure() {
      if DefaultData.shared.data?.count ?? -1 > 0 {
         let sum = DefaultData.shared.data!.map { $0.price }
         self.minPriceLabel.text = Preferences.priceToWon(price: sum[0])
         self.avePriceLabel.text = Preferences.priceToWon(price: sum.reduce(0, +) / sum.count)
         self.stationCountLabel.text = String(sum.count) + "개"
      } else {
         self.minPriceLabel.text = "0원"
         self.avePriceLabel.text = "0원"
         self.stationCountLabel.text = "0개"
      }
      self.radiusLabel.text = String(DefaultData.shared.radius / 1000) + "KM"
   }
}
