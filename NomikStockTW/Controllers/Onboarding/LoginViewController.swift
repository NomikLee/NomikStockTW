//
//  LoginViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/20.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    // MARK: - Variables
    private let authViewModel = AuthViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.systemBlue.cgColor
        ]
        return gradientLayer
    }()
    
    private let loginEmailLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "E-mail"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let loginEmailTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.keyboardType = .emailAddress
        textfield.layer.cornerRadius = 10
        textfield.attributedPlaceholder = NSAttributedString(string: " 請輸入email...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let loginPasswordLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let loginPasswordTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.isSecureTextEntry = true
        textfield.textColor = .black
        textfield.layer.cornerRadius = 10
        textfield.passwordRules = UITextInputPasswordRules(descriptor: "")
        textfield.textContentType = .oneTimeCode
        textfield.attributedPlaceholder = NSAttributedString(string: " 請輸入password...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(loginEmailLable)
        view.addSubview(loginEmailTextView)
        view.addSubview(loginPasswordLable)
        view.addSubview(loginPasswordTextView)
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        configureUI()
        bindView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Functions
    private func bindView() {
        loginEmailTextView.addTarget(self, action: #selector(didChangeLoginEmailField), for: .editingChanged)
        loginPasswordTextView.addTarget(self, action: #selector(didChangeLoginPasswordField), for: .editingChanged)
        
        authViewModel.$isAuthValid.receive(on: DispatchQueue.main)
            .sink { [weak self] valid in
                self?.loginButton.isEnabled = valid
            }
            .store(in: &cancellables)
        
        //當創造一個帳號後user不為nil檢查 navigationController 的 viewControllers 組中的第一個viewController是否為 StartedViewController是的話刪除
        authViewModel.$user.receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard user != nil else { return }
                let loadVC = UINavigationController(rootViewController: ReloadViewController())
                loadVC.modalPresentationStyle = .fullScreen
                self?.present(loadVC, animated: false)
            }
            .store(in: &cancellables)
        
        authViewModel.$error.receive(on: DispatchQueue.main)
            .sink { [weak self] errorString in
                guard let error = errorString else { return }
                self?.errorAlert(error)
            }
            .store(in: &cancellables)
    }
    
    private func errorAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    // MARK: - Selectors
    @objc private func didChangeLoginPasswordField() {
        authViewModel.passwordText = loginPasswordTextView.text
        authViewModel.checkLoginAuthText()
    }
    
    @objc private func didChangeLoginEmailField() {
        authViewModel.emailText = loginEmailTextView.text
        authViewModel.checkLoginAuthText()
    }
    
    @objc private func didTapLogin() {
        authViewModel.loginUser()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            loginEmailLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginEmailLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginEmailLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            loginEmailLable.heightAnchor.constraint(equalToConstant: 50),
            
            loginEmailTextView.leadingAnchor.constraint(equalTo: loginEmailLable.leadingAnchor),
            loginEmailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginEmailTextView.topAnchor.constraint(equalTo: loginEmailLable.bottomAnchor),
            loginEmailTextView.heightAnchor.constraint(equalToConstant: 50),
            
            loginPasswordLable.leadingAnchor.constraint(equalTo: loginEmailTextView.leadingAnchor),
            loginPasswordLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginPasswordLable.topAnchor.constraint(equalTo: loginEmailTextView.bottomAnchor, constant: 5),
            loginPasswordLable.heightAnchor.constraint(equalToConstant: 50),
            
            loginPasswordTextView.leadingAnchor.constraint(equalTo: loginPasswordLable.leadingAnchor),
            loginPasswordTextView.trailingAnchor.constraint(equalTo: loginEmailTextView.trailingAnchor),
            loginPasswordTextView.topAnchor.constraint(equalTo: loginPasswordLable.bottomAnchor),
            loginPasswordTextView.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: loginPasswordTextView.centerXAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginPasswordTextView.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: loginPasswordTextView.bottomAnchor, constant: 20),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
// MARK: - Extension
