//
//  InventoryTableViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/14.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "InventoryTableViewCell"
    
    private let titleLabel: [UILabel] = ["股名", "股數", "成本", "賺賠"].map { title in
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }
    
    // MARK: - UI Components
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: titleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .systemBackground
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.layoutMargins = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.borderColor = UIColor.systemOrange.cgColor
        stackView.layer.borderWidth = 2
        stackView.layer.cornerRadius = 5
        return stackView
    }()
    
    private let colloctionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleStackView)
        addSubview(colloctionView)
        
        colloctionView.delegate = self
        colloctionView.dataSource = self
        
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
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleStackView.widthAnchor.constraint(equalToConstant: 60),
            
            colloctionView.topAnchor.constraint(equalTo: titleStackView.topAnchor),
            colloctionView.leadingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            colloctionView.bottomAnchor.constraint(equalTo: titleStackView.bottomAnchor),
            colloctionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
}
// MARK: - Extension
extension InventoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
}

extension InventoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
}
