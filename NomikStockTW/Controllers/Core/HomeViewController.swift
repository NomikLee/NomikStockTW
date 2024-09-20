//
//  HomeViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit
import Combine
import FirebaseAuth

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Variables
    private let selectionBarView = SelectionBarView()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OptionalStocksTableViewCell.self, forCellReuseIdentifier: OptionalStocksTableViewCell.identifier)
        tableView.register(StocksRankTableViewCell.self, forCellReuseIdentifier: StocksRankTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeTableView)
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        //重新整理
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        homeTableView.refreshControl = refreshControl
        
        //Header畫面
        let homeHeaderView = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 160))
        homeTableView.tableHeaderView = homeHeaderView
        
        publisherFN()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCurrentUser()
    }
    
    // MARK: - Functions
    private func checkCurrentUser() {
        if Auth.auth().currentUser == nil {
            dismiss(animated: false) {
                let vc = UINavigationController(rootViewController: StartedViewController())
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    private func publisherFN(){
        PublisherManerger.shared.signOutButtonTapPublisher
            .sink { [weak self] in
                try? Auth.auth().signOut()
                self?.checkCurrentUser()
            }
            .store(in: &cancellables)
        
        
        PublisherManerger.shared.userHeaderImageTapPublisher
            .sink { [weak self] in
                let userSettingVC = UserSettingViewController()
                userSettingVC.modalPresentationStyle = .automatic
                self?.present(userSettingVC, animated: true)
            }
            .store(in: &cancellables)
        
        PublisherManerger.shared.pushOptionalStockCollectionCell
            .sink { [weak self] stockCode in
                let fastOrderVC = FastOrderViewController()
                fastOrderVC.title = stockCode
                self?.navigationController?.pushViewController(fastOrderVC, animated: true)
            }
            .store(in: &cancellables)
        
        PublisherManerger.shared.pushStockRankCollectionCell
            .sink { [weak self] stockCode in
                let fastOrderVC = FastOrderViewController()
                fastOrderVC.title = stockCode
                self?.navigationController?.pushViewController(fastOrderVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    @objc private func refreshData() {
        PublisherManerger.shared.favoriteRefreshPublisher.send()
        PublisherManerger.shared.updateTotelMoneyPublisher.send()
        homeTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.homeTableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - UI Setup
}

// MARK: - Extension
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 140
        default:
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionalStocksTableViewCell.identifier, for: indexPath) as? OptionalStocksTableViewCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksRankTableViewCell.identifier, for: indexPath) as? StocksRankTableViewCell else { return UITableViewCell() }
            
            PublisherManerger.shared.selectionPublisher
                .sink { [weak self] selection in
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
    
    //section的內容
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

