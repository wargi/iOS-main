//
//  SettingTableViewController.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 11..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

// 주유소 탐색 설정 페이지
// 사용자 유종과 탐색 반경을 변경하면 메인페이지에 업데이트 되어 적용 된다.
// 설정 저장 방식은 피리스트('UserInfo'에 저장)
// ** 탐색반경 : 3KM, 유종 : nil **
class SettingTableViewController: UITableViewController {
   
   @IBOutlet private weak var oilTypeLabel : UILabel! // 현재 탐색 하고 있는 오일의 타입
   @IBOutlet private weak var findLabel : UILabel! // 현재 탐색 하고 있는 탐색 반경
   @IBOutlet private weak var findBrandType : UILabel! // 현재 탐색 하고 있는 브랜드
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationSetting()
      settingDataLoad()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UIApplication.shared.statusBarStyle = .lightContent
   }
   
   func navigationSetting() {
      let backButtonItem = UIBarButtonItem()
      backButtonItem.title = ""
      backButtonItem.tintColor = UIColor.white
      self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButtonItem
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundEB", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.white]
   }
   
   // 이전 설정을 데이터를 불러와서
   // oilTypeLabel, findLabel, findBrandType 업데이트
   func settingDataLoad() {
      oilTypeLabel.text = Preferences.oil(code: DefaultData.shared.oilType)
      findLabel.text = String(DefaultData.shared.radius / 1000) + "KM"
      findBrandType.text = Preferences.brand(code: DefaultData.shared.brandType)
   }
   
   // 다른 페이지로 전환 시
   // 현재 SettingTableViewController에 cell에 표시 된 설정 값을
   // 넘겨 주는 페이지의 selected 설정 값의 이름을 전달한다.
   // ex) oilType(휘발유) -> selectedOilTypeName(휘발유) 전달
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "SelectOilType", let oilType = oilTypeLabel.text {
         let controller = segue.destination as! SelectOilTypeTableViewController
         controller.selectedOilTypeName = oilType
      } else if segue.identifier == "FindDistance", let findDistance = findLabel.text {
         let controller = segue.destination as! SelectFindDistanceTableViewController
         controller.selectedDistance = findDistance
      } else if segue.identifier == "SelectBrandType", let findBrand = findBrandType.text {
         let controller = segue.destination as! SelectGasstationTableViewController
         controller.selectedBrand = findBrand
      }
   }
   
   // SelectOilTypeTableViewController에서 오일 타입 선택 시
   // SettingTableViewController로 페이지가 전환(pop)되면서
   // SettingTableViewController의 oilTypeLabel를 업데이트 해주고
   // 앱의 기본정보 객체의(DefaultData) oilType을 Update 해준다.
   @IBAction private func didPickerOilType(_ segue: UIStoryboardSegue) {
      let controller = segue.source as! SelectOilTypeTableViewController
      oilTypeLabel.text = controller.selectedOilTypeName
      DefaultData.shared.oilType = Preferences.oil(name: controller.selectedOilTypeName)
      DefaultData.shared.saveOil()
   }
   
   // SelectFindDistanceTableViewController에서 탐색 반경 선택 시
   // SettingTableViewController로 페이지가 전환(pop)되면서
   // SettingTableViewController의 findLabel를 업데이트 해주고
   // 앱의 기본정보 객체의(DefaultData) radius를 Update 해준다.
   @IBAction private func didPickerDistance(_ segue: UIStoryboardSegue) {
      let controller = segue.source as! SelectFindDistanceTableViewController
      findLabel.text = controller.selectedDistance
      DefaultData.shared.radius = Preferences.distanceKM(KM: controller.selectedDistance)
      DefaultData.shared.saveDistance()
   }
   
   // SelectGasstationTableViewController에서 브랜드 선택 시
   // SettingTableViewController로 페이지가 전환(pop)되면서
   // SettingTableViewController의 findBrandType를 업데이트 해주고
   // 앱의 기본정보 객체의(DefaultData) brandType를 Update 해준다.
   @IBAction private func didPickerBrandType(_ segue: UIStoryboardSegue) {
      let controller = segue.source as! SelectGasstationTableViewController
      findBrandType.text = controller.selectedBrand
      DefaultData.shared.brandType = Preferences.brand(name: controller.selectedBrand)
      DefaultData.shared.saveBrand()
   }
   
   // 앱스토어 연결
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 2 && indexPath.row == 1 {
         let id = "1435350344"
         if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(id)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
            // 유효한 URL인지 검사
            if #available(iOS 10.0, *) { //iOS 10.0부터 URL를 오픈하는 방법이 변경 되었습니다.
               UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
            } else {
               UIApplication.shared.openURL(reviewURL)
            }
         }
      }
   }
}

