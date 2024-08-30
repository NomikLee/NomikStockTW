//
//  StocksRankTableViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/5.
//

import UIKit
import Combine

protocol CollectionPushStockRankDelegate: AnyObject {
    func pushStockRankCollectionCell(_ stockCode: String)
}

class StocksRankTableViewCell: UITableViewCell {
   
    // MARK: - Variables
    static let identifier = "StocksRankTableViewCell"
    weak var delegate: CollectionPushStockRankDelegate?
    
    private var stockFetchDatasViewModel = StockFetchDatasViewModels()
    private var selectNum: Int?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //調整layout長寬
        layout.itemSize = CGSize(width: 360, height: 70)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StocksRankCollectionViewCell.self, forCellWithReuseIdentifier: StocksRankCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bindView()
        
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.bindView()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Functions
    private func bindView() {
        stockFetchDatasViewModel.moversUPFetchDatas()
        stockFetchDatasViewModel.$moversUPDatas.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }
        .store(in: &cancellables)
        
        stockFetchDatasViewModel.moversDOWNFetchDatas()
        stockFetchDatasViewModel.volumeActivesFetchDatas()
        stockFetchDatasViewModel.valueActivesFetchDatas()
    }
    
    public func configureSelectNum(with num: Int) {
        self.selectNum = num
        self.collectionView.reloadData()
    }
    
    
    // MARK: - Selectors
    // MARK: - UI Setup
}

// MARK: - Extension
extension StocksRankTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StocksRankCollectionViewCell.identifier, for: indexPath) as? StocksRankCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemGray2
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.systemOrange.cgColor
        
        
        switch selectNum {
        case 0:
            cell.configureDatas(
                with: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].name ?? "",
                titleNum: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].symbol ?? "",
                price: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].closePrice ?? 0.0,
                increasePrice: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].change ?? 0.0,
                pricePercent: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].changePercent ?? 0.0
            )
        case 1:
            cell.configureDatas(
                with: stockFetchDatasViewModel.moversDOWNDatas?.data[indexPath.row].name ?? "",
                titleNum: stockFetchDatasViewModel.moversDOWNDatas?.data[indexPath.row].symbol ?? "",
                price: stockFetchDatasViewModel.moversDOWNDatas?.data[indexPath.row].closePrice ?? 0.0,
                increasePrice: stockFetchDatasViewModel.moversDOWNDatas?.data[indexPath.row].change ?? 0.0,
                pricePercent: stockFetchDatasViewModel.moversDOWNDatas?.data[indexPath.row].changePercent ?? 0.0
            )
        case 2:
            cell.configureDatas(
                with: stockFetchDatasViewModel.volumeActivesDatas?.data[indexPath.row].name ?? "",
                titleNum: stockFetchDatasViewModel.volumeActivesDatas?.data[indexPath.row].symbol ?? "",
                price: stockFetchDatasViewModel.volumeActivesDatas?.data[indexPath.row].closePrice ?? 0.0,
                increasePrice: stockFetchDatasViewModel.volumeActivesDatas?.data[indexPath.row].change ?? 0.0,
                pricePercent: stockFetchDatasViewModel.volumeActivesDatas?.data[indexPath.row].changePercent ?? 0.0
            )
        case 3:
            cell.configureDatas(
                with: stockFetchDatasViewModel.valueActivesDatas?.data[indexPath.row].name ?? "",
                titleNum: stockFetchDatasViewModel.valueActivesDatas?.data[indexPath.row].symbol ?? "",
                price: stockFetchDatasViewModel.valueActivesDatas?.data[indexPath.row].closePrice ?? 0.0,
                increasePrice: stockFetchDatasViewModel.valueActivesDatas?.data[indexPath.row].change ?? 0.0,
                pricePercent: stockFetchDatasViewModel.valueActivesDatas?.data[indexPath.row].changePercent ?? 0.0
            )
        default:
            cell.configureDatas(
                with: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].name ?? "",
                titleNum: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].symbol ?? "",
                price: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].closePrice ?? 0.0,
                increasePrice: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].change ?? 0.0,
                pricePercent: stockFetchDatasViewModel.moversUPDatas?.data[indexPath.row].changePercent ?? 0.0
            )
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? StocksRankCollectionViewCell
        if let title = cell?.stockTitleNumLabel.text {
            delegate?.pushStockRankCollectionCell(title)
        }
    }
}


