//
//  NoticeTableViewCell.swift
//  OilPrice-Where
//
//  Created by Himchan Park on 31/08/2018.
//  Copyright © 2018 sangwook park. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
   
   @IBOutlet weak var titleLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
}
