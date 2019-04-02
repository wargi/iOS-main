//
//  MainListCoreLocation.swift
//  OilPrice-Where
//
//  Created by 박소정 on 14/03/2019.
//  Copyright © 2019 sangwook park. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - CLLocationManagerDelegate
extension MainListViewController: CLLocationManagerDelegate {
   
   func locationManager(_ manager: CLLocationManager, // 위치 관리자가 위치를 얻을 수 없을 때
      didFailWithError error: Error) {
      print("did Fail With Error \(error)")
      
      // CLError.locationUnknown: 현재 위치를 알 수 없는데 Core Location이 계속 위치 정보를 요청할 때
      // CLError.denied: 사용자가 위치 서비스를 사용하기 위한 앱 권한을 거부
      // CLError.network: 네트워크 관련 오류
      if (error as NSError).code == CLError.locationUnknown.rawValue {
         return
      }
      
      // CLError.locationUnknown의 오류 보다 더 심각한 오류가 발생하였을 때
      // lastLocationError에 오류를 저장한다.
      lastLocationError = error
      stopLocationManager()
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let newLocation = locations.last else { return }
      
      currentCoordinate = newLocation.coordinate
      
      let katecPoint = Converter.convertWGS84ToKatec(coordinate: self.appleMapView.centerCoordinate)
      print(self.appleMapView.centerCoordinate)
      print(newLocation.coordinate)
      if !performingReverseGeocoding {
         performingReverseGeocoding = true
         geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
            placemarks, error in
            self.lastGeocodingError = error
            // 에러가 없고, 주소 정보가 있으며 주소가 공백이지 않을 시
            if error == nil, let p = placemarks, !p.isEmpty {
               self.currentPlacemark = p.last!
            } else {
               self.currentPlacemark = nil
            }
            
            self.performingReverseGeocoding = false
            self.headerView.configure(with: self.string(from: self.currentPlacemark))
         })
      }
      
      if let lastLocation = oldLocation {
         let distance: CLLocationDistance = newLocation.distance(from: lastLocation)
         let mapDistance = newLocation.distance(from: CLLocation(latitude: appleMapView.centerCoordinate.latitude,
                                                                 longitude: appleMapView.centerCoordinate.longitude))
         print(mapDistance)
         if mapDistance < 50.0 &&
            lastOilType == DefaultData.shared.oilType &&
            lastFindRadius == DefaultData.shared.radius &&
            lastBrandType == DefaultData.shared.brandType &&
            lastFavorites == DefaultData.shared.favoriteArr {
            stopLocationManager()
            self.tableView.reloadData()
         } else {
            reset()
            oldLocation = newLocation
            gasStationListData(katecPoint: KatecPoint(x: katecPoint.x, y: katecPoint.y))
            stopLocationManager()
            lastOilType = DefaultData.shared.oilType
            lastFindRadius = DefaultData.shared.radius
            lastBrandType = DefaultData.shared.brandType
//            zoomToLatestLocation(with: currentCoordinate!)
         }
      } else {
         reset()
         zoomToLatestLocation(with: currentCoordinate!)
         oldLocation = newLocation
         gasStationListData(katecPoint: KatecPoint(x: katecPoint.x, y: katecPoint.y))
         stopLocationManager()
      }
      
      // 인증 상태가 변경 되었을 때
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationUpdates(locationManager: manager)
         }
      }
   }
}
