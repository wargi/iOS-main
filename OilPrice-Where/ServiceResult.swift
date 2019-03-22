//
//  ServiceResult.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 25..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import Foundation

enum Result<T> {
   case success(T)
   case error(Error)
}

enum ServiceError: Error {
   case invalidURL
   case parsingError
}
