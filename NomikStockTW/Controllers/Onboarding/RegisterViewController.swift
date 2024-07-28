//
//  RegisterViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/20.
//

import UIKit
import Combine
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    // MARK: - Variables
    private var viewModel = AuthViewModels()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let emailTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "E-mail"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let emailTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.keyboardType = .emailAddress
        textfield.layer.cornerRadius = 10
        textfield.attributedPlaceholder = NSAttributedString(string: " 請輸入email...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let passwordTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let passwordTextView: UITextField = {
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
    
    private let passwordCheckTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Check Password"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let passwordCheckTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.isSecureTextEntry = true
        textfield.textColor = .black
        textfield.layer.cornerRadius = 10
        textfield.passwordRules = UITextInputPasswordRules(descriptor: "")
        textfield.textContentType = .oneTimeCode
        textfield.attributedPlaceholder = NSAttributedString(string: " 再次輸入password...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let firstNameTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "First Name"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let firstNameTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.layer.cornerRadius = 10
        textfield.attributedPlaceholder = NSAttributedString(string: " 請輸入你的姓...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let lastNameTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Last Name"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let lastNameTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.layer.cornerRadius = 10
        textfield.attributedPlaceholder = NSAttributedString(string: " 請輸入你的名...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Creat Account", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.isEnabled = false
        return button
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.systemBlue.cgColor
        ]
        return gradientLayer
    }()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(emailTitleLable)
        view.addSubview(emailTextView)
        view.addSubview(passwordTitleLable)
        view.addSubview(passwordTextView)
        view.addSubview(passwordCheckTitleLable)
        view.addSubview(passwordCheckTextView)
        view.addSubview(firstNameTitleLable)
        view.addSubview(firstNameTextView)
        view.addSubview(lastNameTitleLable)
        view.addSubview(lastNameTextView)
        view.addSubview(confirmButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        confirmButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        configureUI()
        bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Functions
    private func bindViews() {
        emailTextView.addTarget(self, action: #selector(didChangeEmailField), for: .editingChanged)
        passwordTextView.addTarget(self, action: #selector(didChangePasswordField), for: .editingChanged)
        passwordCheckTextView.addTarget(self, action: #selector(didChangePasswordCheckField), for: .editingChanged)
        firstNameTextView.addTarget(self, action: #selector(didChangeFirstNameField), for: .editingChanged)
        lastNameTextView.addTarget(self, action: #selector(didChangeLastNameField), for: .editingChanged)
        
        viewModel.$isAuthValid.sink { [weak self] valid in
            self?.confirmButton.isEnabled = valid
        }
        .store(in: &cancellables)
        
        //當創造一個帳號後user不為nil檢查 navigationController 的 viewControllers 組中的第一個viewController是否為 StartedViewController是的話刪除
        viewModel.$user.sink { [weak self] user in
            guard user != nil else { return }
            guard let vc = self?.navigationController?.viewControllers.first as? StartedViewController else { return }
            vc.dismiss(animated: true)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Selectors
    @objc private func didChangeLastNameField() {
        viewModel.lastNameText = lastNameTextView.text
        viewModel.checkAuthText()
    }
    
    @objc private func didChangeFirstNameField() {
        viewModel.firstNameText = firstNameTextView.text
        viewModel.checkAuthText()
    }
    
    @objc private func didChangePasswordCheckField() {
        viewModel.passwordCheckText = passwordCheckTextView.text
        viewModel.checkAuthText()
    }
    
    @objc private func didChangePasswordField() {
        viewModel.passwordText = passwordTextView.text
        viewModel.checkAuthText()
    }
    
    @objc private func didChangeEmailField() {
        viewModel.emailText = emailTextView.text
        viewModel.checkAuthText()
    }
    
    @objc private func didTapRegister() {
        viewModel.createUser()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UI Setup
    private func configureUI(){
        NSLayoutConstraint.activate([
            emailTitleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTitleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTitleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            emailTitleLable.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextView.leadingAnchor.constraint(equalTo: emailTitleLable.leadingAnchor),
            emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextView.topAnchor.constraint(equalTo: emailTitleLable.bottomAnchor),
            emailTextView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTitleLable.leadingAnchor.constraint(equalTo: emailTextView.leadingAnchor),
            passwordTitleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTitleLable.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 5),
            passwordTitleLable.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextView.leadingAnchor.constraint(equalTo: passwordTitleLable.leadingAnchor),
            passwordTextView.trailingAnchor.constraint(equalTo: emailTextView.trailingAnchor),
            passwordTextView.topAnchor.constraint(equalTo: passwordTitleLable.bottomAnchor),
            passwordTextView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordCheckTitleLable.leadingAnchor.constraint(equalTo: passwordTextView.leadingAnchor),
            passwordCheckTitleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordCheckTitleLable.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor, constant: 5),
            passwordCheckTitleLable.heightAnchor.constraint(equalToConstant: 50),
            
            passwordCheckTextView.leadingAnchor.constraint(equalTo: passwordCheckTitleLable.leadingAnchor),
            passwordCheckTextView.trailingAnchor.constraint(equalTo: passwordTextView.trailingAnchor),
            passwordCheckTextView.topAnchor.constraint(equalTo: passwordCheckTitleLable.bottomAnchor),
            passwordCheckTextView.heightAnchor.constraint(equalToConstant: 50),
            
            firstNameTitleLable.leadingAnchor.constraint(equalTo: passwordCheckTextView.leadingAnchor),
            firstNameTitleLable.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            firstNameTitleLable.topAnchor.constraint(equalTo: passwordCheckTextView.bottomAnchor, constant: 5),
            firstNameTitleLable.heightAnchor.constraint(equalToConstant: 50),
            
            firstNameTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstNameTextView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            firstNameTextView.topAnchor.constraint(equalTo: firstNameTitleLable.bottomAnchor, constant: 5),
            firstNameTextView.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTitleLable.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            lastNameTitleLable.trailingAnchor.constraint(equalTo: passwordCheckTextView.trailingAnchor),
            lastNameTitleLable.topAnchor.constraint(equalTo: firstNameTitleLable.topAnchor),
            lastNameTitleLable.heightAnchor.constraint(equalToConstant: 50),
            
            lastNameTextView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            lastNameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            lastNameTextView.topAnchor.constraint(equalTo: firstNameTextView.topAnchor),
            lastNameTextView.heightAnchor.constraint(equalToConstant: 50),
            
            confirmButton.leadingAnchor.constraint(equalTo: firstNameTextView.centerXAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: lastNameTextView.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: firstNameTextView.bottomAnchor, constant: 20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

}
// MARK: - Extension
