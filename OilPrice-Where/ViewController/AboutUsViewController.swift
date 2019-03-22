//
//  AboutUsViewController.swift
//  OilPrice-Where
//
//  Created by Himchan Park on 06/09/2018.
//  Copyright © 2018 sangwook park. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationItem.leftBarButtonItem?.tintColor = UIColor.white
      navigationSetting()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   
   func navigationSetting() {
      let backButtonItem = UIBarButtonItem()
      backButtonItem.title = ""
      backButtonItem.tintColor = UIColor.white
      self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundEB", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.white]
   }
   
}
