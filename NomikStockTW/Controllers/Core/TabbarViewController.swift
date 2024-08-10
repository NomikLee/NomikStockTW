//
//  TabbarViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隱藏 TabBarItem 欄位的字串
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .selected)

        let vc1 = HomeViewController()
        let vc2 = PortfolioViewController()
        let vc3 = FastOrderViewController()
        let vc4 = HistoryViewController()
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "tray.and.arrow.down")
        vc3.tabBarItem.image = UIImage(systemName: "arrow.down.left.arrow.up.right")
        vc4.tabBarItem.image = UIImage(systemName: "menucard")
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

}
