//
//  MainTabbarController.swift
//  Miselog
//
//  Created by 成田裕之 on 2017/07/23.
//  Copyright © 2017年 Hiroyuki Narita. All rights reserved.
//

import Foundation
import UIKit

class MainTabberController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        /*
        if viewController is CustomerActivityListViewController {
            var casted = (CustomerActivityListViewController)viewController
            casted.updateTableView()
            
        }
        */
        if let casted = viewController as? CustomerActivityListViewController {
            casted.updateTableView()
        }
    }
    

    

}
