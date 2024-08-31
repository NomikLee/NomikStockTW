//
//  TradeListViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/29.
//

import UIKit
import Combine

class TradeListViewController: UIViewController {

    // MARK: - Variables
    private var viewModel = FirestoreViewModels()
    
    private var tradeListArray: [String: [String]] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let tradeListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TradeListTableViewCell.self, forCellReuseIdentifier: TradeListTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tradeListTableView)
        
        tradeListTableView.delegate = self
        tradeListTableView.dataSource = self
        
        let tradeheaderView = TradeHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        tradeListTableView.tableHeaderView = tradeheaderView

        bindView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tradeListTableView.frame = view.bounds
    }
    
    // MARK: - Functions
    private func bindView() {
        viewModel.fetchFirestoreMainData()
        viewModel.$mainDatas.receive(on: DispatchQueue.main)
            .sink { [weak self] dataArray in
                if let dataArray = dataArray?.list {
                    self?.tradeListArray = dataArray
                }
                self?.tradeListTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    
    // MARK: - UI Setup
}

// MARK: - Extension
extension TradeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TradeListTableViewCell.identifier, for: indexPath) as? TradeListTableViewCell else { 
            return UITableViewCell()
        }
        
        cell.configureTradeListData(
            with: "\(tradeListArray["\(indexPath.row)"]?[0] ?? "")",
            listStock: "\(tradeListArray["\(indexPath.row)"]?[1] ?? "").\(tradeListArray["\(indexPath.row)"]?[2] ?? "")",
            listBs: "\(tradeListArray["\(indexPath.row)"]?[3] ?? "")",
            listPrice: "\(tradeListArray["\(indexPath.row)"]?[4] ?? "")")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
