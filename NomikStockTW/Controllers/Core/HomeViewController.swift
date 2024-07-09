//
//  HomeViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    private let homeTitleName: [String] = ["自選股", "上漲排行"]
    private let selectionBarView = SelectionBarView()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionalStocksTableViewCell.self, forCellReuseIdentifier: OptionalStocksTableViewCell.identifier)
        tableView.register(StocksRankTableViewCell.self, forCellReuseIdentifier: StocksRankTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableView)
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        homeTableView.tableHeaderView = HomeHeaderVIew(frame: CGRect(x: 0, y: 0,width: view.bounds.width, height: 290))
        
        
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
        switch indexPath.section {
        case 0:
            return 140
        default:
            return 300
        }
    }
    
    //返回指定位置的cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionalStocksTableViewCell.identifier, for: indexPath) as? OptionalStocksTableViewCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksRankTableViewCell.identifier, for: indexPath) as? StocksRankTableViewCell else { return UITableViewCell() }
            
            selectionBarView.selectionPublisher.sink { [weak self] selection in
                switch selection {
                case .up:
                    cell.configureSelectNum(with: 0)
                case .down:
                    cell.configureSelectNum(with: 1)
                case .volume:
                    cell.configureSelectNum(with: 2)
                case .value:
                    cell.configureSelectNum(with: 3)
                }
            }
            .store(in: &cancellables)
            return cell
        }
    }
    
    //返回section的內容
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return selectionBarView
        } else{
            let label = UILabel()
            label.text = "自選股"
            label.font = .systemFont(ofSize: 24)
            return label
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

