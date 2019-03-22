//
//  headerView.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 14..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

class MainHeaderView: UIView {
   
   @IBOutlet private weak var geoLabel : UILabel!
   
   func configure(with geoCode: String?) {
      guard let geoCode = geoCode else { return }
      geoLabel.text = geoCode
   }
   
}
