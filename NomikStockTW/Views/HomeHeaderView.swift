//
//  HomeHeaderView.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit
import Combine

class HomeHeaderView: UIView {
    
    // MARK: - Variables
    private var firestoreViewModel = FirestoreViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let nameHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hi,____"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let welcomeHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to BestStock"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let userHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let balanceHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let titleBalanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "總資產"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let totalBalanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let totalCurrencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "TWD"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(nameHeaderLabel)
        addSubview(welcomeHeaderLabel)
        addSubview(userHeaderImageView)
        addSubview(balanceHeaderView)
        balanceHeaderView.addSubview(titleBalanceLabel)
        balanceHeaderView.addSubview(totalBalanceLabel)
        balanceHeaderView.addSubview(totalCurrencyLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userHeaderImageViewTap))
        userHeaderImageView.addGestureRecognizer(tapGesture)
        
        configureUI()
        bindView()
        publisherFn()
        updateTotelMoneyFn()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func bindView() {
        
        firestoreViewModel.fetchFirestoreMainData()
        firestoreViewModel.$mainDatas.receive(on: DispatchQueue.main)
            .sink { [weak self] data in
            guard let data = data else { return }
            self?.firestoreViewModel.downloadImage(from: data.imagePath)
            self?.totalBalanceLabel.text = "\(data.money)"
            self?.nameHeaderLabel.text = "Hi \(data.lastName)"
        }
        .store(in: &cancellables)
        
        firestoreViewModel.$userImage.receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.userHeaderImageView.image = image
            }
            .store(in: &cancellables)
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemFill.cgColor
        ]
        gradientLayer.frame = balanceHeaderView.bounds
        balanceHeaderView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func publisherFn() {
        PublisherManerger.shared.logoImageChangePublisher
            .sink { [weak self] in
                self?.bindView()
            }
            .store(in: &cancellables)
    }
    
    private func updateTotelMoneyFn() {
        PublisherManerger.shared.updateTotelMoneyPublisher.sink { [weak self] _ in
            self?.firestoreViewModel.fetchFirestoreMainData()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    @objc private func userHeaderImageViewTap() {
        PublisherManerger.shared.userHeaderImageTapPublisher.send()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        //mainUI
        NSLayoutConstraint.activate([
            nameHeaderLabel.topAnchor.constraint(equalTo: topAnchor),
            nameHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameHeaderLabel.heightAnchor.constraint(equalToConstant: 35),
            nameHeaderLabel.widthAnchor.constraint(equalToConstant: bounds.width/2),
            
            welcomeHeaderLabel.topAnchor.constraint(equalTo: nameHeaderLabel.bottomAnchor),
            welcomeHeaderLabel.leadingAnchor.constraint(equalTo: nameHeaderLabel.leadingAnchor),
            welcomeHeaderLabel.heightAnchor.constraint(equalToConstant: 20),
            welcomeHeaderLabel.widthAnchor.constraint(equalToConstant: bounds.width/2),
            
            userHeaderImageView.topAnchor.constraint(equalTo: nameHeaderLabel.topAnchor),
            userHeaderImageView.bottomAnchor.constraint(equalTo: welcomeHeaderLabel.bottomAnchor),
            userHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userHeaderImageView.heightAnchor.constraint(equalToConstant: 50),
            userHeaderImageView.widthAnchor.constraint(equalToConstant: 50),
            
            balanceHeaderView.topAnchor.constraint(equalTo: userHeaderImageView.bottomAnchor, constant: 20),
            balanceHeaderView.heightAnchor.constraint(equalToConstant: 100),
            balanceHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            balanceHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
        
        //balanceHeaderView sub UI
        NSLayoutConstraint.activate([
            titleBalanceLabel.topAnchor.constraint(equalTo: balanceHeaderView.topAnchor, constant: 20),
            titleBalanceLabel.leadingAnchor.constraint(equalTo: balanceHeaderView.leadingAnchor, constant: 20),
            titleBalanceLabel.trailingAnchor.constraint(equalTo: balanceHeaderView.trailingAnchor),
            titleBalanceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            totalBalanceLabel.topAnchor.constraint(equalTo: titleBalanceLabel.bottomAnchor, constant: 10),
            totalBalanceLabel.leadingAnchor.constraint(equalTo: titleBalanceLabel.leadingAnchor),
            totalBalanceLabel.widthAnchor.constraint(equalToConstant: 250),
            totalBalanceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            totalCurrencyLabel.bottomAnchor.constraint(equalTo: totalBalanceLabel.bottomAnchor),
            totalCurrencyLabel.leadingAnchor.constraint(equalTo: totalBalanceLabel.trailingAnchor),
            totalCurrencyLabel.trailingAnchor.constraint(equalTo: balanceHeaderView.trailingAnchor, constant: -20),
            totalCurrencyLabel.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}
// MARK: - Extension
