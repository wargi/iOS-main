//
//  Scene.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2020/01/21.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

enum Scene {
   case main
   case initial
   case setting
   case selectOil
   case selectDistance
   case selectGasStation
   case favorite
}

extension Scene {
   func instantiate(from storyboard: String = "Main") -> UIViewController {
      let storyboard = UIStoryboard(name: storyboard, bundle: nil)
      
//      switch self {
//      case .main:
//      case .initial:
//      case
//      }
      
      return UIViewController()
   }
}
