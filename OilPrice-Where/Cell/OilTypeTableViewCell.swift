//
//  OilTypeTableViewCell.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 9..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

// 설정 -> 오일 타입 선택 리스트 셀
class OilTypeTableViewCell: UITableViewCell {
   
   @IBOutlet private weak var oilTypeLabel : UILabel! // 오일 종류
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   // 셀 설정
   func configure(typeName: String) {
      oilTypeLabel.text = typeName // 오일의 종류(휘발유, 경유, LPG 등..)를 셀에 표시
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
}
