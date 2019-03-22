//
//  AppDelegate.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2018. 7. 11..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   var mainViewController:MainListViewController?
   let firebaseUtility = FirebaseUtility()
   
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      FirebaseApp.configure()
      firebaseUtility.checkUpdateTime()
      
      DefaultData.shared.allPriceDataLoad() // 전국의 오일종류 별 저번주의 평균 값을 받아온다.
      window?.rootViewController = initialViewController() // 설정페이지 루트뷰 설정
      
      return true
   }
   
   // initialViewController 초기 설정 페이지 관련 함수
   // 처음 앱을 켰을 때 저장 되어있는 오일 타입이 설정 되어 있지 않을 시에
   // 초기 설정 페이지(InitialSettingViewController)를 루트 뷰로 설정
   // 오일 타입이 있다면 메인 리스트 페이지(TabBarController)를 루트뷰로 설정
   private func initialViewController() -> UIViewController {
      if DefaultData.shared.oilType == "" {
         return UIStoryboard(name: "Main",
                             bundle: nil).instantiateViewController(withIdentifier: "InitialSettingViewController")
      } else {
         return UIStoryboard(name: "Main",
                             bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
      }
   }
   
   func applicationWillResignActive(_ application: UIApplication) {
   }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
      mainViewController?.configureLocationServices() // 앱이 포어 그라운드로 돌아 올 때 위치정보 리플레쉬
   }
   
   func applicationDidBecomeActive(_ application: UIApplication) {
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
   }
   
   
}

