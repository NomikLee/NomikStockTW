//
//  TradeListTableViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/29.
//

import UIKit
import Combine

class TradeListTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "TradeListTableViewCell"
    
    // MARK: - UI Components
    private var listLabel: [UILabel] = ["2024/08/29", "0050.元大台灣50", "+20000", "1900"].map { title in
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .systemOrange
        return label
    }
    
    private lazy var listStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: listLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(listStackView)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    public func configureTradeListData(with listDate: String, listStock: String, listBs: String, listPrice: String) {
        for (key, data) in listStackView.arrangedSubviews.enumerated() {
            guard let data = data as? UILabel else { return }
            
            switch key {
            case 0:
                data.text = listDate
            case 1:
                data.text = listStock
            case 2:
                data.text = listBs
            default:
                data.text = listPrice
            }
        }
    }
    
    // MARK: - Selectors
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            listStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listStackView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
// MARK: - Extension
