//
//  API.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 25..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

private let baseURL = "http://www.opinet.co.kr/api"

// API Protocol
protocol APIProtocol
{
   var urlString: String { get }
}

enum API: APIProtocol {
   
   // ======= API 사용법 =======
   // LIST를 API URL 열거형으로 정의
   // 참조) String format에 아규먼트 값을 넣을 경우 필요한 형식
   // %d = Int, %ld = Double, %f = Float, %@ = String
   // %.4f 는 Float의 소숫점 4자리까지만 표기함, 참고로 API에 사용되는 위도 경도 값은 소숫점 6자리 까지
   // %03 는 000, 001, 002 로 형 변환하며, %02는 01, 02, 03 로 형 변환
   // ======= API 내부 파라미터 =======
   // prodcd = 휘발유:B027, 경유:D047, 고급휘발유: B034, C004:실내등유, 자동차부탄: K015 (미입력시 모든 제품)
   // area = 지역구분 (미입력시 전국, 시도코드(2자리):해당시도 기준, 시군코드(4자리):해당시군 기준)
   // x,y = 기준 위치 X,Y좌표 (KATEC)
   // radius = 반경 선택 ( 최대 5000, 단위 :m)
   // sort = 1: 가격순, 2: 거리순
   // osnm = 상호 검색명 (검색어 두글자 이상)
   
   enum LIST: String {
      // 전국 주유소 평균 가격
      case avgAll = "/avgAllPrice.do?out=json&code=%@"
      // 시도별 주유소 평균 가격
      case avgSido = "/avgSidoPrice.do?prodcd=%@&sido=%02d&out=json&code=%@"
      // 시군구별 주유소 평균 가격
      case avgSigun = "/avgSigunPrice.do?prodcd=%@&sigun=%04d&sido=%02d&out=json&code=%@"
      // 최근 7일간 전국 일일 평균 가격
      case avgRecent = "/avgRecentPrice.do?prodcd=%@&out=json&code=%@"
      // 최근 1주의 주간 평균 유가(전국/시도별)
      case avgLastWeek = "/avgLastWeek.do?prodcd=%@&code=%@&out=json"
      // 지역별 최저가 주유소(Top10)
      case lowTop10 = "/lowTop10.do?area=%04d&prodcd=%@&out=json&code=%@"
      // 반경내 주유소 검색
      case aroundAll = "/aroundAll.do?x=%.5f&y=%.5f&radius=%d&prodcd=%@&sort=%d&out=json&code=%@"
      // 주유소 상세 정보
      case detailById = "/detailById.do?code=%@&id=%@&out=json"
      // 지역 코드
      case areaCode = "/areaCode.do?out=json&code=%@&area=%@"
      // 상호로 주유소 검색
      case searchByName = "/searchByName.do?code=%@&out=json&osnm=%@"
   }
   
   // API List
   case avgAll(appKey: String) // 전국 주유소 평균 가격
   case avgSido(prodcd: String, sido: Int, appKey: String) // 시도별 주유소 평균 가격
   case avgSigun(prodcd: String, sigun: Int, sido: Int, appKey: String) // 시군구별 주유소 평균 가격
   case avgRecent(prodcd: String, appKey: String) // 최근 7일간 전국 일일 평균 가격
   case avgLastWeek(prodcd: String, appKey: String) // 최근 1주의 주간 평균 유가(전국/시도별)
   case lowTop10(prodcd: String, area: String, appKey: String) // 지역별 최저가 주유소(Top10)
   case aroundAll(x: Double, y: Double, radius: Int, prodcd: String, sort: Int, appKey: String) // 반경내 주유소
   case detailById(appKey: String, id: String) // 주유소 상세 정보
   case areaCode(area: String, appKey: String) // 지역 코드
   case searchByName(appKey: String, osnm: String) // 상호로 주유소 검색
   
   
   // endPoint에 파라미터 값을 반환하는 변수
   private var endpointString: String {
      get {
         var tempString: String = ""
         switch self {
         case .avgAll(let appKey): // 전국 주유소 평균 가격
            tempString = String(format: LIST.avgAll.rawValue, appKey)
         case .avgSido(let prodcd, let sido, let appKey): // 시도별 주유소 평균 가격
            tempString = String(format: LIST.avgSido.rawValue, prodcd, sido, appKey)
         case .avgSigun(let prodcd, let sigun, let sido, let appKey): // 시군구별 주유소 평균 가격
            tempString = String(format: LIST.avgSigun.rawValue, prodcd, sigun, sido, appKey)
         case .avgRecent(let prodcd, let appKey): // 최근 7일간 전국 일일 평균 가격
            tempString = String(format: LIST.avgRecent.rawValue, prodcd, appKey)
         case .avgLastWeek(let prodcd, let appKey): // 최근 1주의 주간 평균 유가(전국/시도별)
            tempString =  String(format: LIST.avgLastWeek.rawValue, prodcd, appKey)
         case .lowTop10(let prodcd, let area, let appKey): // 지역별 최저가 주유소(Top10)
            tempString = String(format: LIST.lowTop10.rawValue, prodcd, area, appKey)
         case .aroundAll(let x, let y, let radius, let prodcd, let sort, let appKey): // 반경내 주유소
            tempString = String(format: LIST.aroundAll.rawValue, x, y, radius, prodcd, sort, appKey)
         case .detailById(let appKey, let id): // 주유소 상세 정보
            tempString = String(format: LIST.detailById.rawValue, appKey, id)
         case .areaCode(let area, let appKey): // 지역 코드
            tempString = String(format: LIST.areaCode.rawValue, area, appKey)
         case .searchByName(let appKey, let osnm): // 상호로 주유소 검색
            tempString = String(format: LIST.searchByName.rawValue, appKey, osnm)
         }
         //tempString URL로 변경
         return tempString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      }
   }
   
   // 기본 URL 주소와 Endpoint를 합쳐주는 변수
   var urlString: String {
      get {
         return baseURL + self.endpointString
      }
   }
}
