//
//  InitialSettingViewController.swift
//  OilPrice-Where
//
//  Created by 박상욱n 2018. 8. 19..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

// 초기 설정 페이지
class InitialSettingViewController: UIViewController {
   
   @IBOutlet private weak var scrollView : UIScrollView! // 페이지 표시 스크롤 뷰
   lazy var scrollWidth = scrollView.bounds.size.width // 스크롤 뷰의 Width값 저장
   @IBOutlet private weak var okButton : UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      okButton.layer.cornerRadius = 6
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      UIApplication.shared.statusBarStyle = .default // Status Bar Color
   }
   
   // 확인 버튼 클릭 이벤트
   @IBAction private func okAction(_ sender: UIButton) {
      let selectedOil = scrollView.bounds.origin.x / scrollWidth // 선택한 오일 종류
      
      switch selectedOil {
      case 1:
         DefaultData.shared.oilType = "D047" // 두번째 페이지 선택 경유
      case 2:
         DefaultData.shared.oilType = "K015" // 세번째 페이지 선택 LPG
      case 3:
         DefaultData.shared.oilType = "B034" // 네번째 페이지 선택 고급휘발유
      default:
         DefaultData.shared.oilType = "B027" // 첫번째 페이지 선택 휘발유
      }
      DefaultData.shared.saveOil()
   }
   
   // 왼쪽 버튼 클릭 이벤트
   // 왼쪽 버튼 클릭 시 이전 페이지로 이동
   @IBAction private func leftAction(_ sender: UIButton) {
      if scrollView.contentOffset.x > 0 {
         UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset.x -= self.scrollWidth
         }
      }
   }
   
   // 오른쪽 버튼 클릭 이벤트
   // 오른쪽 버튼 클릭 시 다음 페이지로 이동
   @IBAction private func rightAction(_ sender: UIButton) {
      if scrollView.contentOffset.x < scrollWidth * 3 {
         UIView.animate(withDuration: 0.2) {
            self.scrollView.contentOffset.x += self.scrollWidth
         }
      }
   }
}
