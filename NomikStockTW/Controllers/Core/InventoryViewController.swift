//
//  InventoryViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit
import Combine

class InventoryViewController: UIViewController {
    
    // MARK: - Variables
    private let viewModel = FirestoreViewModels()
    
    private var dataArray: [String: [String]] = [:]
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let inventoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InventoryCollectionViewCell.self, forCellWithReuseIdentifier: InventoryCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .systemRed
        return view
    }()
    
    private let titleLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let titleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "股名"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let titleStockNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "庫存數"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let titleCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "成本"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let titleProfitLossLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "賺賠"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let totelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 7
        view.layer.borderColor = UIColor.systemOrange.cgColor
        return view
    }()
    
    private let totelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "總共資金: "
        label.textColor = .systemBlue
        return label
    }()
    
    private let totelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "------- 元"
        return label
    }()
    
    private let stockValueTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "股票價值: "
        label.textColor = .systemBlue
        return label
    }()
    
    private let stockValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "180950 元"
        return label
    }()
    
    private let availableTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "剩餘資金: "
        label.textColor = .systemBlue
        return label
    }()
    
    private let availableFundsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1820000 元"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inventory"
        view.addSubview(inventoryCollectionView)
        view.addSubview(totelView)
        view.addSubview(titleView)
        view.addSubview(titleLineView)
        titleView.addSubview(titleNameLabel)
        titleView.addSubview(titleStockNumLabel)
        titleView.addSubview(titleCostLabel)
        titleView.addSubview(titleProfitLossLabel)
        totelView.addSubview(totelTitle)
        totelView.addSubview(totelLabel)
        totelView.addSubview(stockValueTitle)
        totelView.addSubview(stockValueLabel)
        totelView.addSubview(availableTitle)
        totelView.addSubview(availableFundsLabel)
        
        inventoryCollectionView.delegate = self
        inventoryCollectionView.dataSource = self
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.circlepath"), style: .plain, target: self, action: #selector(reroadTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .plain, target: self, action: #selector(tradeListTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        configureUI()
        bindView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inventoryCollectionView.frame = view.bounds
    }
    
    // MARK: - Functions
    private func bindView(){
        viewModel.fetchFirestoreMainData()
        viewModel.$mainDatas.receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.totelLabel.text = data?.money
                if let dataArrays = data?.treasury {
                    self?.dataArray = dataArrays
                }
                self?.inventoryCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    @objc private func reroadTapped() {
        cancellables.forEach { $0.cancel() }  // 清理現有的訂閱
        cancellables.removeAll()
        
        viewModel.fetchFirestoreMainData()
        viewModel.$mainDatas.receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                if let dataArrays = data?.treasury {
                    self?.dataArray = dataArrays
                }
                self?.inventoryCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func tradeListTapped() {
        let vc = TradeListViewController()
        vc.title = "交易紀錄"
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UI Setup
    private func configureUI(){
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.bottomAnchor.constraint(equalTo: totelView.topAnchor),
            titleView.widthAnchor.constraint(equalToConstant: view.bounds.width/5.2),
            
            titleNameLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 30),
            titleNameLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleNameLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            titleLineView.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 30),
            titleLineView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLineView.heightAnchor.constraint(equalToConstant: 10),
            
            titleStockNumLabel.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 80),
            titleStockNumLabel.leadingAnchor.constraint(equalTo: titleNameLabel.leadingAnchor),
            titleStockNumLabel.trailingAnchor.constraint(equalTo: titleNameLabel.trailingAnchor),
            titleStockNumLabel.heightAnchor.constraint(equalToConstant: 50),
            
            titleCostLabel.topAnchor.constraint(equalTo: titleStockNumLabel.bottomAnchor, constant: 80),
            titleCostLabel.leadingAnchor.constraint(equalTo: titleStockNumLabel.leadingAnchor),
            titleCostLabel.trailingAnchor.constraint(equalTo: titleStockNumLabel.trailingAnchor),
            titleCostLabel.heightAnchor.constraint(equalToConstant: 50),
            
            titleProfitLossLabel.topAnchor.constraint(equalTo: titleCostLabel.bottomAnchor, constant: 80),
            titleProfitLossLabel.leadingAnchor.constraint(equalTo: titleCostLabel.leadingAnchor),
            titleProfitLossLabel.trailingAnchor.constraint(equalTo: titleCostLabel.trailingAnchor),
            titleProfitLossLabel.heightAnchor.constraint(equalToConstant: 50),
            
            totelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totelView.heightAnchor.constraint(equalToConstant: 150),
            
            totelTitle.leadingAnchor.constraint(equalTo: totelView.leadingAnchor, constant: 40),
            totelTitle.topAnchor.constraint(equalTo: totelView.topAnchor, constant: 25),
            totelTitle.widthAnchor.constraint(equalToConstant: 100),
            totelTitle.heightAnchor.constraint(equalToConstant: 15),
            
            totelLabel.leadingAnchor.constraint(equalTo: totelTitle.trailingAnchor),
            totelLabel.topAnchor.constraint(equalTo: totelTitle.topAnchor),
            totelLabel.trailingAnchor.constraint(equalTo: totelView.trailingAnchor),
            totelLabel.heightAnchor.constraint(equalToConstant: 15),
            
            stockValueTitle.leadingAnchor.constraint(equalTo: totelTitle.leadingAnchor),
            stockValueTitle.topAnchor.constraint(equalTo: totelTitle.bottomAnchor, constant: 25),
            stockValueTitle.widthAnchor.constraint(equalToConstant: 100),
            stockValueTitle.heightAnchor.constraint(equalToConstant: 15),
            
            stockValueLabel.leadingAnchor.constraint(equalTo: stockValueTitle.trailingAnchor),
            stockValueLabel.topAnchor.constraint(equalTo: stockValueTitle.topAnchor),
            stockValueLabel.trailingAnchor.constraint(equalTo: totelView.trailingAnchor),
            stockValueLabel.heightAnchor.constraint(equalToConstant: 15),
            
            availableTitle.leadingAnchor.constraint(equalTo: stockValueTitle.leadingAnchor),
            availableTitle.topAnchor.constraint(equalTo: stockValueTitle.bottomAnchor, constant: 25),
            availableTitle.widthAnchor.constraint(equalToConstant: 100),
            availableTitle.heightAnchor.constraint(equalToConstant: 15),
            
            availableFundsLabel.leadingAnchor.constraint(equalTo: availableTitle.trailingAnchor),
            availableFundsLabel.topAnchor.constraint(equalTo: availableTitle.topAnchor),
            availableFundsLabel.trailingAnchor.constraint(equalTo: totelView.trailingAnchor),
            availableFundsLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
}

// MARK: - Extension
extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InventoryCollectionViewCell.identifier, for: indexPath) as? InventoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        
        switch indexPath.row {
        case 0:
            cell.isHidden = true
        default:
            cell.isHidden = false
            cell.backgroundColor = .secondaryLabel
            cell.configureInventoryData(
                with: dataArray["\(indexPath.row)"]?[0] ?? "",
                stockName: dataArray["\(indexPath.row)"]?[1] ?? "",
                stockNum: dataArray["\(indexPath.row)"]?[2] ?? "",
                stockCost: dataArray["\(indexPath.row)"]?[3] ?? "",
                StockProfitLoss: "111")
        }
        return cell
    }
}

extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topSafeArea = view.safeAreaInsets.top
        let bottomSafeArea = view.safeAreaInsets.bottom
        let availableHeight = view.bounds.height - topSafeArea - bottomSafeArea
        
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.frame.width/5.2, height: availableHeight)
        default:
            return CGSize(width: collectionView.frame.width/2.5, height: availableHeight)
        }
    }
}
