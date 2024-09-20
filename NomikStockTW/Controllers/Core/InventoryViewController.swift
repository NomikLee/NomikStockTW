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
    private let firestoreViewModel = FirestoreViewModels()
    private let stockFetchDatasViewModel = StockFetchDatasViewModels()
    
    private var stockTotel: Double = 0.0
    private var profitAndLossTotal: Double = 0.0
    
    private var profitLossNum: [String : Double] = [:]
    private var profitAndLoss: [String : String] = [:]
    private var profitLossCost: [String : Double] = [:]
    private var treasuryDataArrays: [String: [String]] = [:]
    private var listDataArrays: [String: [String]] = [:]
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
        label.text = "現價"
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
    
    private let inStockTotelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "庫存賺賠: "
        label.textColor = .systemBlue
        return label
    }()
    
    private let inStockTotelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "------- 元"
        return label
    }()
    
    private let stockValueTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "花費成本: "
        label.textColor = .systemBlue
        return label
    }()
    
    private let stockValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "------- 元"
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
        label.text = "------- 元"
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
        totelView.addSubview(inStockTotelTitle)
        totelView.addSubview(inStockTotelLabel)
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
        
        if cancellables.isEmpty {
            firestoreViewModel.fetchFirestoreMainData()
            firestoreViewModel.$mainDatas.receive(on: DispatchQueue.main)
                .sink { [weak self] datas in
                    guard let treasurys = datas?.treasury, let listDatas = datas?.list, let moneys = datas?.money else { return }
                    
                    let filterTreasurys = treasurys.filter { !$0.value.contains("0") }
                    let filterZeroTreasurys = Array(treasurys.filter { $0.value.contains("0") }.values)
                    var filterZeroLists = []
                    
                    for i in filterZeroTreasurys {
                        filterZeroLists.append(i[0])
                    }
                    
                    let filterlistDatas = listDatas.filter { listData in
                        !filterZeroLists.contains { filterZeroList in
                            listData.value.contains("\(filterZeroList)")
                        }
                    }
                    
                    self?.treasuryDataArrays = filterTreasurys
                    self?.listDataArrays = filterlistDatas
                    
                    
                    if let values = self?.listDataArrays.values {
                        let reArrays = Set(values.map{ $0[1] })
                        self?.stockFetchDatasViewModel.profitAndLossQuoteFetchDatas(with: Array(reArrays))
                        for reArray in reArrays {
                            self?.stockTotel = 0.0
                            if let singleValue = self?.listDataArrays.filter{ $0.value[1] == "\(reArray)" } {
                                let date = singleValue.values.map{ $0[0] }
                                let stockCode = singleValue.values.map{ $0[1] }
                                let buySellNum = singleValue.values.map{ $0[3] }.compactMap{ Double($0)}
                                let buySellPrice = singleValue.values.map{ $0[4] }.compactMap{ Double($0)}
                                
                                self?.profitLossNum[stockCode[0]] = buySellNum.reduce(0.0){ $0 + $1 }
                                
                                for (num, price) in zip(buySellNum, buySellPrice) {
                                    self!.stockTotel += num * price
                                }
                                self?.profitLossCost[stockCode[0]] = self!.stockTotel
                            }
                        }
                        
                        guard let profitLossCosts = self?.profitLossCost else { return }
                        let cost = profitLossCosts.values.map{ abs($0) }.reduce(0.0){ $0 + $1 }
                        self?.stockValueLabel.text = "\(cost)"
                        self?.availableFundsLabel.text = "\(Double(moneys)! - cost)"
                        self?.calculateTotal()
                    }
                    self?.inventoryCollectionView.reloadData()
                }
                .store(in: &cancellables)
            
            stockFetchDatasViewModel.$profitAndLossQuoteDatas.receive(on: DispatchQueue.main)
                .sink { [weak self] datas in
                    guard let closePrice = datas?.closePrice, let symbol = datas?.symbol else { return }

                    self?.profitAndLoss["\(symbol)"] = "\(closePrice)"
                    guard let pLN = self?.profitLossNum["\(symbol)"],
                            let pAL = self?.profitAndLoss["\(symbol)"],
                                let pLC = self?.profitLossCost else { return }
                    
                    self?.profitAndLossTotal += pLN * Double(pAL)!
                    self?.inStockTotelLabel.text = "\(self!.profitAndLossTotal - pLC.values.reduce(0.0){ $0 + $1 })"
                    self?.calculateTotal()
                    self?.inventoryCollectionView.reloadData()
                }
                .store(in: &cancellables)
        }
    }
    
    private func calculateTotal() {
        guard let inStockTotalText = inStockTotelLabel.text,
              let availableFundsText = availableFundsLabel.text,
              let stockValueText = stockValueLabel.text,
                let inStockTotal = Double(inStockTotalText),
                let availableFunds = Double(availableFundsText),
                let stockValue = Double(stockValueText) else { return }
            
            
        var totalMoney = Int(inStockTotal + availableFunds + stockValue)
        
        firestoreViewModel.updateMoneyData(with: "\(totalMoney)")

    }
    
    // MARK: - Selectors
    @objc private func reroadTapped() {
        
        stockTotel = 0.0
        profitAndLossTotal = 0.0
        profitLossNum.removeAll()
        profitAndLoss.removeAll()
        profitLossCost.removeAll()
        treasuryDataArrays.removeAll()
        listDataArrays.removeAll()
        
        firestoreViewModel.fetchFirestoreMainData()
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
            
            inStockTotelTitle.leadingAnchor.constraint(equalTo: totelView.leadingAnchor, constant: 40),
            inStockTotelTitle.topAnchor.constraint(equalTo: totelView.topAnchor, constant: 25),
            inStockTotelTitle.widthAnchor.constraint(equalToConstant: 100),
            inStockTotelTitle.heightAnchor.constraint(equalToConstant: 15),
            
            inStockTotelLabel.leadingAnchor.constraint(equalTo: inStockTotelTitle.trailingAnchor),
            inStockTotelLabel.topAnchor.constraint(equalTo: inStockTotelTitle.topAnchor),
            inStockTotelLabel.trailingAnchor.constraint(equalTo: totelView.trailingAnchor),
            inStockTotelLabel.heightAnchor.constraint(equalToConstant: 15),
            
            stockValueTitle.leadingAnchor.constraint(equalTo: inStockTotelTitle.leadingAnchor),
            stockValueTitle.topAnchor.constraint(equalTo: inStockTotelTitle.bottomAnchor, constant: 25),
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
        return treasuryDataArrays.count + 1
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
            
            let treasuryArray = Array(self.treasuryDataArrays.values)
            
            cell.configureInventoryData(
                with: treasuryArray[indexPath.row - 1][0],
                stockName: treasuryArray[indexPath.row - 1][1],
                stockNum: treasuryArray[indexPath.row - 1][2],
                stockCost: "\(self.profitLossCost["\(treasuryArray[indexPath.row - 1][0])"] ?? 0.0)",
                StockProfitLoss: self.profitAndLoss[treasuryArray[indexPath.row - 1][0]] ?? "")
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
