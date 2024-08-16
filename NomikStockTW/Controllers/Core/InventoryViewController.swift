//
//  InventoryViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit

class InventoryViewController: UIViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Components
    private let titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .systemRed
        return view
    }()
    
    private let totelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .systemTeal
        return view
    }()
    
    private let titleLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let titleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "股名"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let titleStockNumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "庫存數"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let titleCostLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "成本"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let titleProfitLossLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "賺賠"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let inventoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InventoryCollectionViewCell.self, forCellWithReuseIdentifier: InventoryCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inventory"
        view.addSubview(inventoryCollectionView)
        view.addSubview(totelView)
        view.addSubview(titleView)
        view.addSubview(titleLineView)
        titleView.addSubview(titleNameLabel)
        titleView.addSubview(titleStockNumLabel)
        titleView.addSubview(titleCostLabel)
        titleView.addSubview(titleProfitLossLabel)
        
        inventoryCollectionView.delegate = self
        inventoryCollectionView.dataSource = self
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        inventoryCollectionView.frame = view.bounds
    }
    
    // MARK: - Functions
    // MARK: - Selectors
    
    // MARK: - UI Setup
    private func configureUI(){
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleView.bottomAnchor.constraint(equalTo: totelView.topAnchor),
            titleView.widthAnchor.constraint(equalToConstant: view.bounds.width/5),
            
            titleNameLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 30),
            titleNameLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleNameLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            titleNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            titleLineView.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 30),
            titleLineView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLineView.heightAnchor.constraint(equalToConstant: 10),
            
            titleStockNumLabel.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 80),
            titleStockNumLabel.leadingAnchor.constraint(equalTo: titleNameLabel.leadingAnchor),
            titleStockNumLabel.trailingAnchor.constraint(equalTo: titleNameLabel.trailingAnchor),
            titleStockNumLabel.heightAnchor.constraint(equalToConstant: 50),
            
            titleCostLabel.topAnchor.constraint(equalTo: titleStockNumLabel.bottomAnchor, constant: 80),
            titleCostLabel.leadingAnchor.constraint(equalTo: titleStockNumLabel.leadingAnchor),
            titleCostLabel.trailingAnchor.constraint(equalTo: titleStockNumLabel.trailingAnchor),
            titleCostLabel.heightAnchor.constraint(equalToConstant: 50),
            
            titleProfitLossLabel.topAnchor.constraint(equalTo: titleCostLabel.bottomAnchor, constant: 80),
            titleProfitLossLabel.leadingAnchor.constraint(equalTo: titleCostLabel.leadingAnchor),
            titleProfitLossLabel.trailingAnchor.constraint(equalTo: titleCostLabel.trailingAnchor),
            titleProfitLossLabel.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            
            totelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totelView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: - Extension
extension InventoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InventoryCollectionViewCell.identifier, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
}

extension InventoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let topSafeArea = view.safeAreaInsets.top
        let bottomSafeArea = view.safeAreaInsets.bottom
        let availableHeight = view.bounds.height - topSafeArea - bottomSafeArea
        
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.frame.width/5, height: availableHeight)
        default:
            return CGSize(width: collectionView.frame.width/2, height: availableHeight)
        }
    }
}
