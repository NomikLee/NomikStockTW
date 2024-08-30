//
//  TradeHeaderView.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit

class TradeHeaderView: UIView {
    
    // MARK: - Variables
    
    // MARK: - UI Components
    private var listTitleLabel: [UILabel] = ["日期", "股票", "買賣", "價格"].map{ title in
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }
    
    private lazy var listTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: listTitleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(listTitleStackView)
        
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
            listTitleStackView.topAnchor.constraint(equalTo: topAnchor),
            listTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listTitleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            listTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Extension
}
