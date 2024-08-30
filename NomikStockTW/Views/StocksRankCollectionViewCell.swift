//
//  StocksRankCollectionViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/5.
//

import UIKit

class StocksRankCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "StocksRankCollectionViewCell"
    private var viewModel = StockFetchDatasViewModels()
    
    // MARK: - UI Components
    private var stockTitleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-----"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    public let stockTitleNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "----"
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$----"
        label.textColor = .label
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let stockIncreasePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "---(----%)"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stockTitleNameLabel)
        contentView.addSubview(stockTitleNumLabel)
        contentView.addSubview(stockPriceLabel)
        contentView.addSubview(stockIncreasePriceLabel)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    public func configureDatas(with titleName: String, titleNum: String, price: Double, increasePrice: Double, pricePercent: Double) {
        self.stockTitleNameLabel.text = titleName
        self.stockTitleNumLabel.text = titleNum
        self.stockPriceLabel.text = "\(price)"
        
        if increasePrice > 0 {
            self.stockIncreasePriceLabel.text = "\(increasePrice)(\(pricePercent)%)"
            self.stockIncreasePriceLabel.textColor = .systemRed
        } else if increasePrice < 0 {
            self.stockIncreasePriceLabel.text = "\(increasePrice)(\(pricePercent)%)"
            self.stockIncreasePriceLabel.textColor = .systemGreen
        } else {
            self.stockIncreasePriceLabel.text = "\(increasePrice)(\(pricePercent)%)"
            self.stockIncreasePriceLabel.textColor = .white
        }
    }
    // MARK: - Selectors
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            stockTitleNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stockTitleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stockTitleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockTitleNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stockTitleNumLabel.topAnchor.constraint(equalTo: stockTitleNameLabel.bottomAnchor, constant: 5),
            stockTitleNumLabel.leadingAnchor.constraint(equalTo: stockTitleNameLabel.leadingAnchor),
            stockTitleNumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockTitleNumLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stockPriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            stockPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockPriceLabel.heightAnchor.constraint(equalToConstant: 30),
            stockPriceLabel.widthAnchor.constraint(equalToConstant: 100),
            
            stockIncreasePriceLabel.topAnchor.constraint(equalTo: stockPriceLabel.bottomAnchor),
            stockIncreasePriceLabel.trailingAnchor.constraint(equalTo: stockPriceLabel.trailingAnchor),
            stockIncreasePriceLabel.heightAnchor.constraint(equalToConstant: 30),
            stockIncreasePriceLabel.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    // MARK: - Extension
    
    
}
