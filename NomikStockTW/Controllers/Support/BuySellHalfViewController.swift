//
//  BuySellHalfViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/19.
//

import UIKit
import Combine

class BuySellHalfViewController: UIViewController {
    
    // MARK: - Variables
    private var symbol: String?
    private var stockName: String?
    private var stockPrice: String?
    private let firestoreViewModel = FirestoreViewModels()
    
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
    
    private let stockNumTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemOrange.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20, weight: .heavy)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.backgroundColor = .black
        return textField
    }()
    
    private let numStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "(股)"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemOrange
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
        stepper.stepValue = 1
        stepper.maximumValue = 499000
        stepper.value = 0
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
    init(title: String, stockName: String, stockPrice: String, Symbol: String) {
        super.init(nibName: nil, bundle: nil)
        buySellTitle.text = title
        self.symbol = Symbol
        self.stockName = stockName
        self.stockPrice = stockPrice
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
        view.addSubview(stockNumTextField)
        view.addSubview(numStockLabel)
        
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
            stockNumTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
            stockNumTextField.text = "\(Int(stepNum.value))"
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.purple.cgColor]
            stepNum.addTarget(self, action: #selector(stepValue), for: .valueChanged)
            buySellButton.addTarget(self, action: #selector(Tapbuy), for: .touchUpInside)
        }else {
            stockNumTextField.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
            stockNumTextField.text = "\(Int(stepNum.value))"
            gradientLayer.colors = [UIColor.green.cgColor, UIColor.purple.cgColor]
            stepNum.addTarget(self, action: #selector(stepValue), for: .valueChanged)
            buySellButton.addTarget(self, action: #selector(TapSell), for: .touchUpInside)
        }
    }
    
    // MARK: - Selectors
    @objc func stepValue(_ sender: UIStepper) {
        stockNumTextField.text = "\(Int(sender.value))"
    }
    
    @objc func textFieldChange(_ textField: UITextField) {
        stepNum.value = Double(textField.text!) ?? 0
    }
    
    @objc func Tapbuy() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowDay = dateFormatter.string(from: Date())
        
//        print("\(nowDay) 購買了\(self.symbol!) \(self.stockName!) +\(stockNumTextField.text!) 股 \(self.stockPrice!)")
        
        let updateBuyData = [
            "": ["\(self.symbol!)", "\(self.stockName!)", "+\(stockNumTextField.text!)", "\(self.stockPrice!)"],
        ]
        
        let updateListBuyData = [
            "": ["\(nowDay)", "\(self.symbol!)", "\(self.stockName!)", "+\(stockNumTextField.text!)", "\(self.stockPrice!)"],
        ]
        
        firestoreViewModel.updateListData(with: updateListBuyData)
        firestoreViewModel.updateTreasuryData(with: updateBuyData)
        
        let alertController = UIAlertController(title: "購買完成", message: "\(nowDay) 購買了\(self.symbol!) \(self.stockName!) +\(stockNumTextField.text!) 股 \(self.stockPrice!)", preferredStyle: .alert)
            
        let confirm = UIAlertAction(title: "確認", style: .default) { _ in
        }
        alertController.addAction(confirm)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func TapSell() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowDay = dateFormatter.string(from: Date())
        
//        print("購買了\(self.symbol!) \(self.stockName!) -\(stockNumTextField.text!) 股 \(self.stockPrice!)")
        
        let updateSellData = [
            "": ["\(self.symbol!)", "\(self.stockName!)", "-\(stockNumTextField.text!)", "\(self.stockPrice!)"],
        ]
        
        let updateListBuyData = [
            "": ["\(nowDay)", "\(self.symbol!)", "\(self.stockName!)", "-\(stockNumTextField.text!)", "\(self.stockPrice!)"],
        ]
        
        firestoreViewModel.updateListData(with: updateListBuyData)
        firestoreViewModel.updateTreasuryData(with: updateSellData)
        
        let alertController = UIAlertController(title: "賣出完成", message: "購買了\(self.symbol!) \(self.stockName!) -\(stockNumTextField.text!) 股 \(self.stockPrice!)", preferredStyle: .alert)
            
        let confirm = UIAlertAction(title: "確認", style: .default) { _ in
        }
        alertController.addAction(confirm)
        
        present(alertController, animated: true, completion: nil)
    }
    
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
            stepNum.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            
            stockNumTextField.bottomAnchor.constraint(equalTo: stepNum.topAnchor, constant: -10),
            stockNumTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stockNumTextField.widthAnchor.constraint(equalToConstant: 150),
            stockNumTextField.heightAnchor.constraint(equalToConstant: 70),
            
            numStockLabel.centerYAnchor.constraint(equalTo: stockNumTextField.centerYAnchor),
            numStockLabel.leadingAnchor.constraint(equalTo: stockNumTextField.trailingAnchor, constant: 5),
            numStockLabel.widthAnchor.constraint(equalToConstant: 50),
            numStockLabel.heightAnchor.constraint(equalToConstant: 40),
            
            buySellButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buySellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buySellButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buySellButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
// MARK: - Extension
