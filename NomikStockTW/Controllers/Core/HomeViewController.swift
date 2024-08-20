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
    private let homeTitleName: [String] = ["自選股", "上漲排行"]
    private let selectionBarView = SelectionBarView()
    private var viewModel = FirestoreViewModels()
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
        
        let homeHeaderView = HomeHeaderVIew(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 240))
        homeHeaderView.delegate = self
        homeTableView.tableHeaderView = homeHeaderView
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: .didReceiveMessage, object: nil)
        
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
    
    // MARK: - Selectors
    @objc private func handleNotification(_ notification: Notification) {
        if let stockCode = notification.object as? String {
            let vc = FastOrderViewController()
            vc.title = stockCode
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup

}

// MARK: - Extension
extension HomeViewController: UITableViewDataSource, UITableViewDelegate, CollectionPushStockRankDelegate {
    func pushStockRankCollectionCell(_ indexPush: Int, stockCode: String) {
        let vc = FastOrderViewController()
        vc.title = stockCode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTitleName.count
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
            
            cell.delegate = self
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

extension HomeViewController: HomeHeaderViewDelegate {
    
    func didTapUserHeaderImage() {
        let userSettingVC = UserSettingViewController()
        userSettingVC.delegate = self
        userSettingVC.modalPresentationStyle = .automatic
        present(userSettingVC, animated: true)
    }
}

extension HomeViewController: logoutDelegate {
    func logoutButtonTap() {
        try? Auth.auth().signOut()
        checkCurrentUser()
    }
}

