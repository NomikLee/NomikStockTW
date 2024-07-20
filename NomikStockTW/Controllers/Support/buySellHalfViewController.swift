//
//  buySellHalfViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/19.
//

import UIKit

class buySellHalfViewController: UIViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Components
    private let buySellTitleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let buySellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()
    
    private let stepNum: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.value = 1
        stepper.stepValue = 1
        stepper.minimumValue = 1
        return stepper
    }()
    
    private let buySellButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("送出", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        return button
    }()
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        buySellTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(stepNum)
        view.addSubview(buySellButton)
        view.addSubview(buySellTitleContainer)
        buySellTitleContainer.layer.addSublayer(gradientLayer)
        buySellTitleContainer.addSubview(buySellTitle)
        
        configureUI()
        configureFN()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = buySellTitleContainer.bounds
    }
    
    // MARK: - Functions
    private func configureFN(){
        
        if buySellTitle.text == "BUY" {
            print("已買入")
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.purple.cgColor]
        }else {
            print("已賣出")
            gradientLayer.colors = [UIColor.green.cgColor, UIColor.purple.cgColor]
        }
    }
    
    // MARK: - Selectors
    
    // MARK: - UI Setup
    private func configureUI(){
        NSLayoutConstraint.activate([
            buySellTitleContainer.topAnchor.constraint(equalTo: view.topAnchor),
            buySellTitleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buySellTitleContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buySellTitleContainer.heightAnchor.constraint(equalToConstant: 100),
            
            buySellTitle.topAnchor.constraint(equalTo: buySellTitleContainer.topAnchor),
            buySellTitle.leadingAnchor.constraint(equalTo: buySellTitleContainer.leadingAnchor),
            buySellTitle.trailingAnchor.constraint(equalTo: buySellTitleContainer.trailingAnchor),
            buySellTitle.bottomAnchor.constraint(equalTo: buySellTitleContainer.bottomAnchor),
            
            stepNum.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepNum.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            
            buySellButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buySellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buySellButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buySellButton.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
}
// MARK: - Extension
