//
//  StocksUPTableViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/5.
//

import UIKit
import Combine

class StocksUPTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "StocksUPTableViewCell"
    
    private var viewModel = StockFetchDatasViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //調整layout長寬
        layout.itemSize = CGSize(width: 360, height: 70)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StocksUPCollectionViewCell.self, forCellWithReuseIdentifier: StocksUPCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        binView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Functions
    private func binView() {
        viewModel.moversUPFetchDatas()
        viewModel.$moversUPDatas.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &cancellables)
    }
    // MARK: - Selectors
    // MARK: - UI Setup
    
    
}

// MARK: - Extension
extension StocksUPTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moversUPDatas?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StocksUPCollectionViewCell.identifier, for: indexPath) as? StocksUPCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 20
        cell.configureDatas(
            with: viewModel.moversUPDatas?.data[indexPath.row].name ?? "",
            titleNum: viewModel.moversUPDatas?.data[indexPath.row].symbol ?? "",
            price: viewModel.moversUPDatas?.data[indexPath.row].closePrice ?? 0.0,
            increasePrice: viewModel.moversUPDatas?.data[indexPath.row].change ?? 0.0,
            pricePercent: viewModel.moversUPDatas?.data[indexPath.row].changePercent ?? 0.0
        )
        
        return cell
    }
    
}


