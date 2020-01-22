//
//  Tansition.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2020/01/21.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation

enum TransitionStyle {
   case root
   case modal
   case push
}

enum TansitionError: Error {
   case navigationControllerMissing
   case cannotPop
   case unknown
}
