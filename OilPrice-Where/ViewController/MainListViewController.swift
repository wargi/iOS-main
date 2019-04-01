//
//  ViewController.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 11..
//  Copyright © 2018년 sangwook park. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import SCLAlertView

class MainListViewController: UIViewController {
   //CoreLocation
   var locationManager = CLLocationManager() // locationManager
   var oldLocation: CLLocation?
   var lastLocationError: Error? // Location Error 확인
   let firebaseUtility = FirebaseUtility()
   
   //Reverse Geocoding
   let geocoder = CLGeocoder() // 지오코딩을 수행할 객체
   var performingReverseGeocoding = false // 아직 위치가 없거나 주소가 일치 하지 않을 때는 주소를 받지 않을 것이므로
   // Bool변수로 받을 지 안받을 지 선택한다.
   var lastGeocodingError: Error? // 문제가 발생 했을 때 오류 저장 변수
   var lastContentOffset: CGFloat = 0 // 테이블 뷰 스크롤의 현재 위치 저장함수
   
   // Map
   @IBOutlet weak var appleMapView: MKMapView! // 맵 뷰
   var currentCoordinate: CLLocationCoordinate2D? // 현재 좌표
   var currentPlacemark: CLPlacemark? // 주소결과가 들어있는 객체
   var annotations: [CustomMarkerAnnotation] = [] // 마커 배열 생성
   @IBOutlet private weak var mapView : UIView! // 애플맵을 포함시키고 있는 뷰
   @IBOutlet private weak var currentLocationButton : UIButton! // 현재 위치 표시 버튼
   @IBOutlet weak var currentLocationButtonTop: NSLayoutConstraint! // 현재 위치 Top Layout
   @IBOutlet private weak var popupView : PopupView!
   var isSelectedAnnotion: Bool = false
   
   // Detail View
   @IBOutlet weak var detailView : DetailView! // Detail View
   
   // TableView
   @IBOutlet weak var tableListView : UIView! // 테이블 뷰를 포함하고 있는 뷰
   @IBOutlet weak var tableView : UITableView! // 메인리스트 테이블 뷰
   var selectIndexPath: IndexPath? // 선택된 인덱스 패스
   var oldIndexPath = IndexPath()
   var refreshControl = UIRefreshControl() // Refresh Controller
   
   // HeaderView
   @IBOutlet weak var toListButton : UIView! //
   @IBOutlet private weak var toImageView : UIImageView!
   @IBOutlet private weak var toLabel : UILabel!
   @IBOutlet weak var headerViewConstraint: NSLayoutConstraint!
   @IBOutlet weak var headerView: MainHeaderView!
   @IBOutlet weak var priceView: UIView!
   
   @IBOutlet private weak var mainProductTitleLabel : UILabel!
   @IBOutlet private weak var mainProductCostLabel : UILabel!
   @IBOutlet private weak var mainProductImageView : UIImageView!
   
   @IBOutlet private weak var secondProductTitleLabel : UILabel!
   @IBOutlet private weak var secondProductCostLabel : UILabel!
   @IBOutlet private weak var secondProductImageView : UIImageView!
   
   @IBOutlet private weak var thirdProductTitleLabel : UILabel!
   @IBOutlet private weak var thirdProductCostLabel : UILabel!
   @IBOutlet private weak var thirdProductImageView : UIImageView!
   
   var mainListPage = true
   var tapGesture = UITapGestureRecognizer()
   var sortData: [GasStation] = []
   
   // StatusBarBackView
   @IBOutlet weak var statusBarBackView: UIView!
   
   //Etc
   let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate // 앱 델리게이트
   var lastKactecX: Double? // KatecX 좌표
   var lastKactecY: Double? // KatecY 좌표
   var lastBrandType = DefaultData.shared.brandType
   var lastOilType = DefaultData.shared.oilType // 마지막 오일 타입
   var lastFindRadius = DefaultData.shared.radius // 마지막 탐색 범위
   var lastFavorites = DefaultData.shared.favoriteArr // 마지막 즐겨 찾기 목록
   var selectMarker = false // 마커 선택 여부
   var lastBottomConstant: CGFloat? // 전환 버튼 애니메이션 관련 Bottom Constraint
   var priceSortButton: UIButton! // 가격 순으로 정렬 해주는 버튼
   var distanceSortButton: UIButton! // 거리 순으로 정렬 해주는 버튼
   var lastSelectedSortButton: UIButton! // 마지막 정렬
   @IBOutlet private weak var noneView: UIView! // 리스트가 아무 것도 없을 때 보여주는 뷰
   @IBOutlet private weak var noneLabel : UILabel! // NoneView에 보여줄 Label
   
   func setStatusBarBackgroundColor(color: UIColor) {
      guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
      statusBar.backgroundColor = color
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setStatusBarBackgroundColor(color: .clear) // StatusBar 배경색 설정
      createSortView() // 가격순, 거리순 버튼 생성 및 설정
      setting() // 기본 설정
      setAverageCosts() // HeaderView 설정
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      // 메인리스트 / 맵 일때 StatusBarStyle 설정
      if mainListPage {
         UIApplication.shared.statusBarStyle = .lightContent
      } else {
         UIApplication.shared.statusBarStyle = .default
      }
      
      // ViewWillAppear시 네트워크 연결 확인
      if Reachability.isConnectedToNetwork() { // 네트워크 연결 시 로케이션 서비스 시작
         configureLocationServices()
      }
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      // 네트워크 연결이 되어 있지 않을 때 Alert 호출
      if !Reachability.isConnectedToNetwork() {
         // Alert 설정
         let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: 300, // Alert Width
            kTitleFont: UIFont(name: "NanumSquareRoundB", size: 18)!, // Alert Title Font
            kTextFont: UIFont(name: "NanumSquareRoundR", size: 15)!, // Alert Content Font
            showCloseButton: true // CloseButton isHidden = True
         )
         
         let alert = SCLAlertView(appearance: appearance)
         alert.showError("네트워크 오류 발생", subTitle: "인터넷 연결이 오프라인 상태입니다.", closeButtonTitle: "확인", colorStyle: 0x5E82FF)
         alert.iconTintColor = UIColor.white
         // 네트워크 연결이 안 되어 있으므로 초기화
         reset()
         DefaultData.shared.data = nil
         sortData = []
         tableView.reloadData()
      }
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      lastBrandType = DefaultData.shared.brandType
      lastOilType = DefaultData.shared.oilType
      lastFindRadius = DefaultData.shared.radius
      lastFavorites = DefaultData.shared.favoriteArr
   }
   
   //Mark: 기본 설정 (viewDidLoad)
   // 가격순, 거리순 버튼 생성
   func createSortView() {
      let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
      
      // 가격순 버튼 설정
      self.priceSortButton = UIButton(frame: CGRect(x: 15, y: 0, width: 45, height: 30))
      self.priceSortButton.setTitle("가격순", for: .normal)
      self.priceSortButton.setTitleColor(UIColor.darkGray, for: .normal)
      self.priceSortButton.setTitleColor(UIColor(named: "MainColor"), for: .selected)
      self.priceSortButton.addTarget(self, action: #selector(self.isTableViewSort(_:)), for: .touchUpInside)
      self.priceSortButton.tag = 1
      self.priceSortButton.isSelected = true
      self.priceSortButton.titleLabel?.font = UIFont(name: "NanumSquareRoundEB", size: 16)
      sectionHeaderView.addSubview(self.priceSortButton)
      
      // 거리순 버튼 설정
      distanceSortButton = UIButton(frame: CGRect(x: 69, y: 0, width: 45, height: 30))
      self.distanceSortButton.setTitle("거리순", for: .normal)
      self.distanceSortButton.setTitleColor(UIColor.darkGray, for: .normal)
      self.distanceSortButton.setTitleColor(UIColor(named: "MainColor"), for: .selected)
      self.distanceSortButton.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 16)
      self.distanceSortButton.addTarget(self, action: #selector(self.isTableViewSort(_:)), for: .touchUpInside)
      self.distanceSortButton.tag = 2
      sectionHeaderView.addSubview(distanceSortButton)
      
      // 기본 설정 버튼(가격순)
      lastSelectedSortButton = priceSortButton
      
      tableView.addSubview(sectionHeaderView)
   }
   
   // 기본 세팅
   func setting() {
      self.noneLabel.font = UIFont(name: "NanumSquareRoundB", size: 17) //NoneView 내의 NoneLabel 설정
      priceView.layer.cornerRadius = 10
      
      // currentLocationButton 설정
      currentLocationButton.layer.cornerRadius = self.currentLocationButton.bounds.height / 2
      currentLocationButton.clipsToBounds = false
      currentLocationButton.layer.shadowColor = UIColor.black.cgColor
      currentLocationButton.layer.shadowOpacity = 0.3
      currentLocationButton.layer.shadowOffset = CGSize(width: 1, height: 1)
      currentLocationButton.layer.shadowRadius = 1.5
      currentLocationButton.addTarget(self, action: #selector(self.currentLoaction(_:)), for: .touchUpInside)
      
      // Draw a shadow
      currentLocationButton.layer.shadowPath = UIBezierPath(roundedRect: currentLocationButton.bounds,
                                                            cornerRadius: self.currentLocationButton.bounds.height / 2).cgPath
      
      // popupView 설정
      popupView.layer.cornerRadius = 7
      popupView.clipsToBounds = true
      popupView.layer.shadowColor = UIColor.black.cgColor
      popupView.layer.shadowOpacity = 0.3
      popupView.layer.shadowOffset = CGSize(width: 1, height: 1)
      popupView.layer.shadowRadius = 1.5
      
      // Draw a shadow
      popupView.layer.shadowPath = UIBezierPath(roundedRect: currentLocationButton.bounds,
                                                cornerRadius: 10).cgPath
      
      // Navigation Bar 색상 설정
      UINavigationBar.appearance().barTintColor = UIColor(named: "MainColor")
      appDelegate.mainViewController = self
      
      // 전환 버튼 설정
      self.toListButton.layer.cornerRadius = self.toListButton.bounds.height / 2
      self.toImageView.image = toImageView.image!.withRenderingMode(.alwaysTemplate)
      self.toImageView.tintColor = UIColor.white
      // 전환 버튼 그림자 설정
      toListButton.clipsToBounds = false
      toListButton.layer.shadowColor = UIColor.black.cgColor
      toListButton.layer.shadowOpacity = 0.5
      toListButton.layer.shadowOffset = CGSize(width: 1, height: 1)
      toListButton.layer.shadowRadius = 2
      
      // Draw a shadow
      toListButton.layer.shadowPath = UIBezierPath(roundedRect: toListButton.bounds, cornerRadius: self.toListButton.bounds.height / 2).cgPath
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.toList(_:)))
      toListButton.addGestureRecognizer(tap)
      
      // 테이블 뷰 헤더 경계 값 설정
      self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      
      // 테이블뷰내에 Refresh 설정
      self.refreshControl.addTarget(self,
                                    action: #selector(refresh),
                                    for: UIControlEvents.valueChanged)
      if #available(iOS 10.0, *) { // iOS 버전 별 설정
         tableView.refreshControl = self.refreshControl
      } else {
         tableView.addSubview(refreshControl)
      }
      
      // 현재 위치 버튼 기종별 설정
      if UIDevice.current.isiPhoneX {
         currentLocationButtonTop.constant = 55
      } else {
         currentLocationButtonTop.constant = 35
      }
   }
   
   // HeaderView 설정
   func setAverageCosts() {
      firebaseUtility.getAverageCost(productName: "gasolinCost") { (data) in
         self.mainProductCostLabel.text = data["price"] as? String ?? ""
         self.mainProductTitleLabel.text = data["productName"] as? String ?? ""
         if data["difference"] as? Bool ?? true {
            self.mainProductImageView.image = #imageLiteral(resourceName: "priceUpIcon")
         }else {
            self.mainProductImageView.image = #imageLiteral(resourceName: "priceDownIcon")
         }
      }
      firebaseUtility.getAverageCost(productName: "dieselCost") { (data) in
         self.secondProductCostLabel.text = data["price"] as? String ?? ""
         self.secondProductTitleLabel.text = data["productName"] as? String ?? ""
         if data["difference"] as? Bool ?? true {
            self.secondProductImageView.image = #imageLiteral(resourceName: "priceUpIcon")
         }else {
            self.secondProductImageView.image = #imageLiteral(resourceName: "priceDownIcon")
         }
         
      }
      firebaseUtility.getAverageCost(productName: "lpgCost") { (data) in
         self.thirdProductCostLabel.text = data["price"] as? String ?? ""
         self.thirdProductTitleLabel.text = data["productName"] as? String ?? ""
         if data["difference"] as? Bool ?? true {
            self.thirdProductImageView.image = #imageLiteral(resourceName: "priceUpIcon")
         } else {
            self.thirdProductImageView.image = #imageLiteral(resourceName: "priceDownIcon")
         }
      }
   }
   
   func reset() {
      appleMapView.removeAnnotations(annotations)
      annotations = []
      selectIndexPath = nil
   }
   func gasStationListData(katecPoint: KatecPoint){
      ServiceList.gasStationList(x: katecPoint.x,
                                 y: katecPoint.y,
                                 radius: DefaultData.shared.radius,
                                 prodcd: DefaultData.shared.oilType,
                                 sort: 1,
                                 appKey: Preferences.getAppKey()) { (result) in
                                    
                                    switch result {
                                    case .success(let gasStationData):
                                       print("DataLoad")
                                       if DefaultData.shared.brandType == "ALL" {
                                          DefaultData.shared.data = gasStationData.result.gasStations
                                       } else {
                                          DefaultData.shared.data = gasStationData.result.gasStations
                                             .filter { $0.brand == DefaultData.shared.brandType }
                                       }
                                       self.sortData = DefaultData.shared.data!.sorted(by: {$0.distance < $1.distance})
                                       self.popupView.configure()
                                       self.showMarker()
                                       self.refreshControl.endRefreshing()
                                       self.tableView.reloadData()
                                       self.isDisplayNoneView()
                                    case .error(let error):
                                       print(error)
                                    }
      }
   }
   
   func isDisplayNoneView() {
      if DefaultData.shared.data?.count == 0 {
         self.noneView.isHidden = false
      } else {
         self.noneView.isHidden = true
      }
   }
   
   //Mark: Display 관련 설정
   // Reload
   @objc func refresh() {
      oldLocation = nil
      reset()
      configureLocationServices()
   }
   
   // TableView List Sort Func(가격, 거리)
   @objc func isTableViewSort(_ sender: UIButton) {
      guard lastSelectedSortButton.tag != sender.tag else {
         return
      }
      
      if sender.tag == priceSortButton.tag { // Sender와 priceButton과 같을 시에 가격순 정렬
         priceSortButton.isSelected = true
         priceSortButton.titleLabel?.font = UIFont(name: "NanumSquareRoundEB", size: 16)
         distanceSortButton.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 16)
         distanceSortButton.isSelected = false
         
         lastSelectedSortButton = priceSortButton
      } else { // 거리순 정렬
         distanceSortButton.isSelected = true
         distanceSortButton.titleLabel?.font = UIFont(name: "NanumSquareRoundEB", size: 16)
         priceSortButton.titleLabel?.font = UIFont(name: "NanumSquareRoundR", size: 16)
         priceSortButton.isSelected = false
         
         lastSelectedSortButton = distanceSortButton
      }
      selectIndexPath = nil
      appleMapView.removeAnnotations(annotations)
      annotations = []
      showMarker()
      tableView.reloadData()
   }
   
   // 전환 액션
   @objc func toList(_ sender: UIView) {
      if mainListPage { // 메인리스트 페이지 일시 맵뷰로 전환
         UIApplication.shared.statusBarStyle = .default // 맵뷰로 전환 시 statusBarStyle
         self.view.sendSubview(toBack: self.tableListView)
         
         // 전환 버튼 애니메이션 관련
         if lastBottomConstant == 10 {
            if let indexPath = selectIndexPath {
               let cell = tableView.cellForRow(at: indexPath) as! GasStationCell
               if cell.stationView.id == detailView.id {
                  if detailView.favoriteButton.isSelected != cell.stationView.favoriteButton.isSelected {
                     self.detailView.clickedEvent(detailView.favoriteButton)
                  }
               }
               self.detailView.detailViewBottomConstraint.constant = 10
               UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
               }
            } else if oldIndexPath != IndexPath() && isSelectedAnnotion {
               let cell = tableView.cellForRow(at: oldIndexPath) as! GasStationCell
               if cell.stationView.id == detailView.id {
                  if detailView.favoriteButton.isSelected != cell.stationView.favoriteButton.isSelected {
                     self.detailView.clickedEvent(detailView.favoriteButton)
                  }
               }
               self.detailView.detailViewBottomConstraint.constant = 10
               UIView.animate(withDuration: 0.3) {
                  self.view.layoutIfNeeded()
               }
            }
         } else {
            self.detailView.detailViewBottomConstraint.constant = -150
            UIView.animate(withDuration: 0.3) {
               self.view.layoutIfNeeded()
            }
         }
         
         toLabel.text = "목록"
         toImageView.image = UIImage(named: "listButton")
         statusBarBackView.isHidden = true
         mainListPage = false
      } else {
         UIApplication.shared.statusBarStyle = .lightContent
         self.view.sendSubview(toBack: self.mapView)
         toImageView.image = UIImage(named: "mapButton")
         toLabel.text = "지도"
         lastBottomConstant = self.detailView.detailViewBottomConstraint.constant
         self.detailView.detailViewBottomConstraint.constant = -150
         UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
         }
         statusBarBackView.isHidden = false
         mainListPage = true
      }
      tableView.reloadData()
   }
   
   //MARK: MapKit 관련
   // 마커 생성
   func showMarker() {
      guard var gasStations = DefaultData.shared.data else { return }
      if distanceSortButton.isSelected {
         gasStations = sortData
      } else {
         gasStations = DefaultData.shared.data!
      }
      
      for (index, gasStation) in gasStations.enumerated() {
         annotations.append(CustomMarkerAnnotation()) // 마커 생성
         annotations[index].coordinate = Converter.convertKatecToWGS(katec: KatecPoint(x: gasStation.katecX, y: gasStation.katecY)) // 마커 위치 선점
         annotations[index].stationInfo = gasStation // 주유소 정보 전달
         self.appleMapView.addAnnotation(annotations[index]) // 맵뷰에 마커 생성
         
      }
   }
   
   // 화면 포커스
   func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
      let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 3000, 3000) // 2km, 2km
      appleMapView.setRegion(zoomRegion, animated: true)
   }
   
   // 맵의 현재위치 버튼
   @objc func currentLoaction(_ sender: UIButton) {
      guard Reachability.isConnectedToNetwork() else { return }
      zoomToLatestLocation(with: currentCoordinate!)
   }
   
   // 지도 보기
   @objc func viewMapAction(annotionIndex gesture: UITapGestureRecognizer) {
      guard let index = self.selectIndexPath?.section else { return }
      
      self.toList(self.toListButton)
      
      appleMapView.selectAnnotation(self.annotations[index], animated: true)
   }
   
   // 길안내 시작
   @objc func navigateStart(_ sender: UITapGestureRecognizer) {
      guard let katecX = lastKactecX?.roundTo(places: 0),
         let katecY = lastKactecY?.roundTo(places: 0) else { return }
      
      let destination = KNVLocation(name: detailView.stationName.text!,
                                    x: NSNumber(value: katecX),
                                    y: NSNumber(value: katecY))
      let options = KNVOptions()
      options.routeInfo = false
      let params = KNVParams(destination: destination,
                             options: options)
      KNVNaviLauncher.shared().navigate(with: params) { (error) in
         self.handleError(error: error)
      }
   }
   
   // 길안내 에러 발생
   func handleError(error: Error?) -> Void {
      if let error = error as NSError? {
         print(error)
         let alert = UIAlertController(title: self.title!,
                                       message: error.localizedFailureReason,
                                       preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel,
                                       handler: nil))
         self.present(alert, animated: true, completion: nil)
      }
   }
   
   // 위치 관련 인증 확인
   @objc func configureLocationServices() {
      locationManager.delegate = self
      appleMapView.delegate = self
      
      let status = CLLocationManager.authorizationStatus() // 현재 인증상태 확인
      if status == .notDetermined { // notDetermined일 시 AlwaysAuthorization 요청
         locationManager.requestWhenInUseAuthorization()
         startLocationUpdates(locationManager: locationManager)
      } else if status == .authorizedAlways || status == .authorizedWhenInUse { // 인증시 위치 정보 받아오기 시작
         startLocationUpdates(locationManager: locationManager)
      } else if status == .restricted || status == .denied {
         let alert = UIAlertController(title: "위치정보를 불러올 수 없습니다.",
                                       message: "위치정보를 사용해 주변 주유소의 정보를 불러오기 때문에 위치정보 사용이 꼭 필요합니다. 설정으로 이동하여 위치 정보 접근을 허용해 주세요.",
                                       preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "취소",
                                          style: .cancel,
                                          handler: nil)
         
         let openAction = UIAlertAction(title: "설정으로 이동",
                                        style: .default) { (action) in
                                          if let url = URL(string: UIApplicationOpenSettingsURLString) {
                                             UIApplication.shared.open(url,
                                                                       options: [String : Any](), completionHandler: nil)
                                          }
         }
         
         alert.addAction(cancelAction)
         alert.addAction(openAction)
         
         self.present(alert, animated: true, completion: nil)
      }
   }
   
   // 위치 요청 시작
   func startLocationUpdates(locationManager: CLLocationManager) {
      appleMapView.showsUserLocation = true
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
   }
   
   // 위치 검색 중지
   func stopLocationManager() {
      locationManager.stopUpdatingLocation()
      locationManager.delegate = nil
   }
   
   // 주소 설정
   func string(from placemark: CLPlacemark?) -> String? {
      guard let currentPlacemark = placemark else {
         return nil
      }
      // address
      var address = ""
      if let s = currentPlacemark.administrativeArea {
         address += s + " "
      }
      if let s = currentPlacemark.locality {
         address += s + " "
      }
      if let s = currentPlacemark.thoroughfare {
         address += s
      }
      return address
   }
}
