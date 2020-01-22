//
//  SceneCoordinatorType.swift
//  OilPrice-Where
//
//  Created by 박상욱 on 2020/01/21.
//  Copyright © 2020 sangwook park. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SceneCoordinatorType {
   @discardableResult
   func transition(to scene: Scene, using style: TransitionStyle, animate: Bool) -> Completable
   
   @discardableResult
   func close(animate: Bool) -> Completable
}

class sceneCoordinator: SceneCoordinatorType {
   private let bag = DisposeBag()
   private var window: UIWindow
   private var currentVC: UIViewController
   
   required init(window: UIWindow) {
      self.window = window
      currentVC = window.rootViewController!
   }
   
   func transition(to scene: Scene, using style: TransitionStyle, animate: Bool) -> Completable {
      let subject = PublishSubject<Void>()
      
      let target = scene.instantiate()
      
      switch style {
      case .root:
         currentVC = target.sceneViewController
         window.rootViewController = target
         subject.onCompleted()
      case .push:
         guard let nav = currentVC.navigationController else {
            subject.onError(TansitionError.navigationControllerMissing)
            break
         }
         
         nav.rx.willShow
            .subscribe(onNext: { [unowned self] event in
               self.currentVC = event.viewController.sceneViewController
            })
            .disposed(by: bag)
         
         nav.pushViewController(target, animated: animate)
         currentVC = target.sceneViewController
         
         subject.onCompleted()
      case .modal:
         currentVC.present(target, animated: animate) {
            subject.onCompleted()
         }
         currentVC = target.sceneViewController
      }
      
      return subject.ignoreElements()
   }
   
   func close(animate: Bool) -> Completable {
      return Completable.create(subscribe: { [unowned self] completable in
         if let presentingVC = self.currentVC.presentingViewController {
            self.currentVC.dismiss(animated: animate) {
               self.currentVC = presentingVC.sceneViewController
               completable(.completed)
            }
         } else if let nav = self.currentVC.navigationController {
            guard nav.popViewController(animated: animate) != nil else {
               completable(.error(TansitionError.cannotPop))
               return Disposables.create()
            }
            self.currentVC = nav.viewControllers.last!
            completable(.completed)
         } else {
            completable(.error(TansitionError.unknown))
         }
         
         return Disposables.create()
      })
   }
   
   
}

extension UIViewController {
   var sceneViewController: UIViewController {
      if let tab = self.tabBarController {
         return tab.childViewControllers.first!
      } else if let nav = self.navigationController {
         return nav.childViewControllers.first!
      } else {
         return self
      }
   }
}
