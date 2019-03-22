//
//  DataUtility.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 25..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation

// MARK: - 코더블 인자 전달 유틸리티
extension Data {
   func decode<T>(_ type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T where T: Decodable {
      return try decoder.decode(type, from: self)
   }
}
