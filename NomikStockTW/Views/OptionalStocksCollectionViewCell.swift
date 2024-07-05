//
//  OptionalStocksCollectionViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/5.
//

import UIKit

class OptionalStocksCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "OptionalStocksCollectionViewCell"
    
    // MARK: - UI Components
    private let stockTitleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "台積電"
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let stockTitleNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2330"
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1010"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let stockIncreasePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-120(-9.98%)"
        label.textColor = .systemGreen
        label.textAlignment = .left
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
            
            stockPriceLabel.topAnchor.constraint(equalTo: stockTitleNumLabel.bottomAnchor, constant: 20),
            stockPriceLabel.leadingAnchor.constraint(equalTo: stockTitleNumLabel.leadingAnchor),
            stockPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockPriceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stockIncreasePriceLabel.topAnchor.constraint(equalTo: stockPriceLabel.bottomAnchor, constant: 5),
            stockIncreasePriceLabel.leadingAnchor.constraint(equalTo: stockPriceLabel.leadingAnchor),
            stockIncreasePriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockIncreasePriceLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    // MARK: - Extension
    
    
}
