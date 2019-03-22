//
//  SelectFindDistanceTableViewController.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 8. 9..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

// 설정 -> 탐색 반경 설정 페이지
class SelectFindDistanceTableViewController: UITableViewController {
   
   var selectedDistance = "" // 선택한 탐색 반경
   var selectedIndexPath: IndexPath? // 선택한 테이블 뷰 셀의 인덱스패스 저장
   let findDistaceArea = [ // 선택 가능한 탐색 반경
      "1KM",
      "3KM",
      "5KM"
   ]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // 네비게이션 타이틀 폰트와 폰트 컬러 변경
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumSquareRoundEB", size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.white]
      
      
      for i in 0 ..< findDistaceArea.count { // selectedDistance를 체크 하여 selectedIndexPath 입력
         if selectedDistance == findDistaceArea[i] {
            selectedIndexPath = IndexPath(row: i, section: 0)
         }
      }
   }
   
   // 설정에서 이전 설정한 탐색 범위를 불러오는 함수
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let cell = sender as! FindDistanceTableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
         self.selectedDistance = findDistaceArea[indexPath.row]
      }
   }
   
   // MARK: - Table view data source
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return findDistaceArea.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "FindDistance", for: indexPath) as! FindDistanceTableViewCell
      
      let findDistance = findDistaceArea[indexPath.row]
      cell.configure(distance: findDistance)
      
      // selectedDistance이 findDistance 같을 시 체크 표시
      if selectedDistance == findDistance {
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
      guard let selectIndexPath = selectedIndexPath else { return }
      if indexPath.row != selectIndexPath.row {
         if let newCell = tableView.cellForRow(at: indexPath) {
            newCell.accessoryType = .checkmark
         }
         if let oldCell = tableView.cellForRow(at: selectIndexPath) {
            oldCell.accessoryType = .none
         }
         self.selectedIndexPath = indexPath
      }
   }
}
