//
//  HomeViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    private let homeTitleName: [String] = ["自選股", "成交量排行", "上漲排行", "下跌排行"]
    
    // MARK: - UI Components
    private let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionalStocksTableViewCell.self, forCellReuseIdentifier: OptionalStocksTableViewCell.identifier)
        tableView.register(StocksVolumeTableViewCell.self, forCellReuseIdentifier: StocksVolumeTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeTableView)
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        homeTableView.tableHeaderView = HomeHeaderVIew(frame: CGRect(x: 0, y: 0,width: view.bounds.width, height: 300))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
    // MARK: - Functions
    // MARK: - Selectors
    // MARK: - UI Setup

}

// MARK: - Extension
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    //返回section的數量
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTitleName.count
    }
    
    //返回指定section中的row行數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //設定Row的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //返回指定位置的cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionalStocksTableViewCell.identifier, for: indexPath) as? OptionalStocksTableViewCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksVolumeTableViewCell.identifier, for: indexPath) as? StocksVolumeTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
    
    //返回每個section的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(homeTitleName[section])"
    }
}

