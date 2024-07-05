//
//  StocksVolumeTableViewCell.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/5.
//

import UIKit

class StocksVolumeTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "StocksVolumeTableViewCell"
    
    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //調整layout長寬
        layout.itemSize = CGSize(width: 200, height: 150)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StocksVolumeCollectionViewCell.self, forCellWithReuseIdentifier: StocksVolumeCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Functions
    // MARK: - Selectors
    // MARK: - UI Setup
    
    
}

// MARK: - Extension
extension StocksVolumeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StocksVolumeCollectionViewCell.identifier, for: indexPath) as? StocksVolumeCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 20
        return cell
    }
    
}
