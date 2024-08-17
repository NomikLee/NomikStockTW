//
//  HomeHeaderVIew.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import UIKit
import Combine

protocol HomeHeaderViewDelegate: AnyObject {
    func didTapUserHeaderImage()
}

class HomeHeaderVIew: UIView {
    
    // MARK: - Variables
    weak var delegate: HomeHeaderViewDelegate?
    
    private var viewModel = FirestoreViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let nameHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hi,Nomik!"
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
    
    private let profitTodayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$1,580 (1.53%)"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .left
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
        balanceHeaderView.addSubview(profitTodayLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userHeaderImageViewTapped))
        userHeaderImageView.addGestureRecognizer(tapGesture)
        
        configureUI()
        bindView()
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
        viewModel.fetchFirestoreMainData()
        viewModel.$mainDatas.receive(on: DispatchQueue.main)
            .sink { [weak self] data in
            guard let data = data else { return }
            self?.totalBalanceLabel.text = data.money
        }
        .store(in: &cancellables)
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemFill.cgColor
        ]
        gradientLayer.frame = balanceHeaderView.bounds
        balanceHeaderView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Selectors
    @objc private func userHeaderImageViewTapped() {
        delegate?.didTapUserHeaderImage()
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
            balanceHeaderView.heightAnchor.constraint(equalToConstant: 150),
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
            totalBalanceLabel.trailingAnchor.constraint(equalTo: titleBalanceLabel.trailingAnchor),
            totalBalanceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            profitTodayLabel.topAnchor.constraint(equalTo: totalBalanceLabel.bottomAnchor, constant: 10),
            profitTodayLabel.leadingAnchor.constraint(equalTo: totalBalanceLabel.leadingAnchor),
            profitTodayLabel.trailingAnchor.constraint(equalTo: totalBalanceLabel.trailingAnchor),
            profitTodayLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    // MARK: - Extension
}
