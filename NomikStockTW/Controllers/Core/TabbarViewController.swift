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

        let vc1 = HomeViewController()
        let vc2 = PortfolioViewController()
        let vc3 = PaperTradeViewController()
        let vc4 = HistoryViewController()
        let vc5 = ProfileViewController()
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "tray.and.arrow.down")
        vc3.tabBarItem.image = UIImage(systemName: "arrow.down.left.arrow.up.right")
        vc4.tabBarItem.image = UIImage(systemName: "menucard")
        vc5.tabBarItem.image = UIImage(systemName: "person")
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        let nav5 = UINavigationController(rootViewController: vc5)
        
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }

}
