//
//  OptionalStocksTableViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/4.
//

import UIKit
import Combine

class OptionalStocksTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "OptionalStocksTableViewCell"
    private let firestoreViewModel = FirestoreViewModels()
    private let stockFetchDatasViewModel = StockFetchDatasViewModels()
    private var stockList: [String] = []
    private var stockDataDict: [String: IntradayQuoteModels] = [:]
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //調整layout長寬
        layout.itemSize = CGSize(width: 150, height: 140)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(OptionalStocksCollectionViewCell.self, forCellWithReuseIdentifier: OptionalStocksCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Functions
    private func bindView(){
        firestoreViewModel.fetchFavoritesCollection()
        firestoreViewModel.$favoritesDatas
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.stockList = data.flatMap { $0.keys }
                self?.fetchFavoritesStockData()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func fetchFavoritesStockData() {
        for symbol in stockList {
            stockFetchDatasViewModel.favoritesIntradayQuoteFetchDatas(with: symbol)
        }
        
        stockFetchDatasViewModel.$favoritesIntradayQuoteDatas
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favoritesQuoteDatas in
                guard let favoritesData = favoritesQuoteDatas else { return }
                self?.stockDataDict[favoritesData.symbol] = favoritesQuoteDatas
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    // MARK: - Selectors
    // MARK: - UI Setup
}

// MARK: - Extension
extension OptionalStocksTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stockList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionalStocksCollectionViewCell.identifier, for: indexPath) as? OptionalStocksCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemPink
        cell.layer.cornerRadius = 20
        
        let symbol = stockList[indexPath.row]
        if let stockData = stockDataDict[symbol] {
            cell.configure(with: stockData.name, stockNum: stockData.symbol, stockPrice: "\(stockData.closePrice)", stockIncreasePrice: "\(stockData.change)(\(stockData.changePercent)%)")
        } else {
            cell.configure(with: "", stockNum: "", stockPrice: "", stockIncreasePrice: "")
        }
        return cell
    }
}
