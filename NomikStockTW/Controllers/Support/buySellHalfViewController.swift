//
//  buySellHalfViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/19.
//

import UIKit

class buySellHalfViewController: UIViewController {
    
    // MARK: - Variables
    private var symbol: String?
    
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
    
    private let switchCurrentButton: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.isOn = false
        return sw
    }()
    
    private let currentTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "一鍵全買"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemOrange
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
    init(title: String, Symbol: String) {
        super.init(nibName: nil, bundle: nil)
        buySellTitle.text = title
        self.symbol = Symbol
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
        view.addSubview(switchCurrentButton)
        view.addSubview(currentTitleLabel)
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
        print("購買了\(self.symbol!) +\(stockNumTextField.text!) 股")
    }
    
    @objc func TapSell() {
        print("購買了\(self.symbol!) -\(stockNumTextField.text!) 股")
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
            
            switchCurrentButton.bottomAnchor.constraint(equalTo: stockNumTextField.topAnchor, constant: -15),
            switchCurrentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            switchCurrentButton.heightAnchor.constraint(equalToConstant: 40),
            switchCurrentButton.widthAnchor.constraint(equalToConstant: 50),
            
            currentTitleLabel.bottomAnchor.constraint(equalTo: stockNumTextField.topAnchor, constant: -20),
            currentTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            currentTitleLabel.widthAnchor.constraint(equalToConstant: 100),
            currentTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            
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
