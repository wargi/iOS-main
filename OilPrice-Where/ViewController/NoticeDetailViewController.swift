//
//  NoticeDetailViewController.swift
//  OilPrice-Where
//
//  Created by Himchan Park on 31/08/2018.
//  Copyright © 2018 sangwook park. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {
   
   
   @IBOutlet weak var contentLable: UILabel!
   
   let content = """
    아직도 운전하다가 아무곳에서 기름을 넣으시나요?
    
    이제는 주변에서 가장 저렴한 주유소를 찾아보세요!
    
    어디주유앱이 도와드립니다.
    
    - 내가 간 주유소 가격이 저렴할까요?
      전국 평균가와 비교해보세요! 바로 알 수 있답니다.

    - 저렴한 주유소를 찾으셨나요?
      카카오네비로 바로 길안내 해드려요.

    - 자주가는 주유소는 즐겨찾기 해주세요!
      직접가서 확인할 필요없이 바로 실시간으로 가격을 알려드립니다.
    """
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      contentLable.text = content
      contentLable.font = UIFont(name: "NanumSquareRoundB", size: 17)
      navigationItem.leftBarButtonItem?.tintColor = UIColor.white
      navigationSetting()
      contentLable.layer.cornerRadius = 6
      
   }
   
   
   
   func navigationSetting() {
      let backButtonItem = UIBarButtonItem()
      backButtonItem.title = ""
      backButtonItem.tintColor = UIColor.white
      self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundEB", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.white]
   }
   
   
}
