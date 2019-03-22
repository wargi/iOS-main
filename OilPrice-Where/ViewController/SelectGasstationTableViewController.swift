//
//  SelectGasstationTableViewController.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 03/01/2019.
//  Copyright © 2019 sangwook park. All rights reserved.
//

import UIKit

class SelectGasstationTableViewController: UITableViewController {
   
   var selectedBrand = "" // 선택한 오일의 종류
   var selectIndexPath:IndexPath? // 선택한 테이블 뷰 셀의 인덱스패스 저장
   let findBrand = [ // 선택 가능한 탐색 반경
      "전체",
      "SK에너지",
      "GS칼텍스",
      "현대오일뱅크",
      "S-OIL",
      "자영알뜰",
      "고속도로알뜰",
      "농협알뜰",
      "자가상표",
      "E1",
      "SK가스"
   ]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundEB", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.white]
      
      brandTypeLoad()
   }
   
   
   // 설정에서 이전 설정한 오일 종류를 불러오는 함수
   func brandTypeLoad() {
      for i in 0..<findBrand.count {
         if findBrand[i] == selectedBrand {
            selectIndexPath = IndexPath(row: i, section: 0)
            break
         }
      }
   }
   
   // 이전 페이지로 돌아 갈 때 선택된 오일 종류를 이전페이지에 전달
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let cell = sender as! BrandTypeTableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
         selectedBrand = findBrand[indexPath.row]
      }
   }
   
   // MARK: - Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return findBrand.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "BrandType", for: indexPath) as! BrandTypeTableViewCell
      
      let brandTypeName = findBrand[indexPath.row]
      cell.configure(typeName: brandTypeName)
      
      // selectedOilTypeName이 cellForRow의 cell의 oilTypeName이 같을 시 체크
      if brandTypeName == selectedBrand {
         cell.accessoryType = .checkmark
      } else {
         cell.accessoryType = .none
      }
      
      return cell
   }
   
   //MARK: TableView Delegate
   // 선택된 인덱스 패스가 이전 선택된 인덱스 패스와 같지 않을 떄
   // 새로운 셀(newCell)에 체크, 이전 셀(oldCell)의 체크를 없앤 후
   // selectIndexPath에 현재 인덱스 패스를 저장
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let selectIndexPath = selectIndexPath else { return }
      if indexPath.row != selectIndexPath.row {
         if let newCell = tableView.cellForRow(at: indexPath) {
            newCell.accessoryType = .checkmark
         }
         if let oldCell = tableView.cellForRow(at: selectIndexPath) {
            oldCell.accessoryType = .none
         }
         self.selectIndexPath = indexPath
      }
   }
}
