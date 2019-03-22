//
//  FindDistanceTableViewCell.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 10..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

// 설정 -> 탐색 반경 선택 리스트 셀
class FindDistanceTableViewCell: UITableViewCell {
   
   @IBOutlet private weak var distanceLabel: UILabel! // 탐색 반경 레이블
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   // 셀 설정
   func configure(distance: String) {
      distanceLabel.text = distance // 탐색 반경 리스트(1,3,5KM)를 셀에 표시
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
}
