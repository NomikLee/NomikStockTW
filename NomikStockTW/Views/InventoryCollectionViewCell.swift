//
//  InventoryCollectionViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/14.
//

import UIKit

class InventoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "InventoryCollectionViewCell"
    
    // MARK: - UI Components
    private let inventoryStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let inventoryStockNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let inventoryStockNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let inventoryStockCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let inventoryStockProfitLossLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(inventoryStockLabel)
        addSubview(inventoryStockNameLabel)
        addSubview(inventoryStockNumLabel)
        addSubview(inventoryStockCostLabel)
        addSubview(inventoryStockProfitLossLabel)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Functions
    public func configureInventoryData(with stock: String, stockName: String, stockNum: String, stockCost: String, StockProfitLoss: String) {
        self.inventoryStockLabel.text = stock
        self.inventoryStockNameLabel.text = stockName
        
        switch stockNum {
        case "":
            self.inventoryStockNumLabel.text = ""
            self.inventoryStockCostLabel.text = ""
            self.inventoryStockProfitLossLabel.text = ""
        default:
            self.inventoryStockNumLabel.text = "\(stockNum) 股"
            self.inventoryStockCostLabel.text = "\(stockCost) 元"
            self.inventoryStockProfitLossLabel.text = "\(StockProfitLoss) 元"
        }
    }
    
    // MARK: - Selectors
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            inventoryStockLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            inventoryStockLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            inventoryStockLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            inventoryStockLabel.heightAnchor.constraint(equalToConstant: 20),
            
            inventoryStockNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            inventoryStockNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            inventoryStockNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            inventoryStockNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            inventoryStockNumLabel.topAnchor.constraint(equalTo: inventoryStockNameLabel.bottomAnchor, constant: 70),
            inventoryStockNumLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            inventoryStockNumLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            inventoryStockNumLabel.heightAnchor.constraint(equalToConstant: 50),
            
            inventoryStockCostLabel.topAnchor.constraint(equalTo: inventoryStockNumLabel.bottomAnchor, constant: 80),
            inventoryStockCostLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            inventoryStockCostLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            inventoryStockCostLabel.heightAnchor.constraint(equalToConstant: 50),
            
            inventoryStockProfitLossLabel.topAnchor.constraint(equalTo: inventoryStockCostLabel.bottomAnchor, constant: 80),
            inventoryStockProfitLossLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            inventoryStockProfitLossLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            inventoryStockProfitLossLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
// MARK: - Extension

