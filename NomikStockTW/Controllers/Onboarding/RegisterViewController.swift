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
    private let genderData = ["Male", "Female"]
    
    
    // MARK: - UI Components
    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.systemBlue.cgColor
        ]
        return gradientLayer
    }()
    
    private let registerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = false
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()
    
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
    
    private let genderTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Gender"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let genderTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.layer.cornerRadius = 10
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: " 您的性別是...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        return textfield
    }()
    
    private let genderPickerview: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let birthdayTitleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "birthday"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let birthdayTextView: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.backgroundColor = .white
        textfield.textColor = .black
        textfield.layer.cornerRadius = 10
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: " 你的生日19900614...", attributes: [ NSAttributedString.Key.foregroundColor : UIColor.gray] )
        return textfield
    }()
    
    private let birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
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

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(registerScrollView)
        registerScrollView.layer.insertSublayer(gradientLayer, at: 0)
        registerScrollView.addSubview(emailTitleLable)
        registerScrollView.addSubview(emailTextView)
        registerScrollView.addSubview(passwordTitleLable)
        registerScrollView.addSubview(passwordTextView)
        registerScrollView.addSubview(passwordCheckTitleLable)
        registerScrollView.addSubview(passwordCheckTextView)
        registerScrollView.addSubview(firstNameTitleLable)
        registerScrollView.addSubview(firstNameTextView)
        registerScrollView.addSubview(lastNameTitleLable)
        registerScrollView.addSubview(lastNameTextView)
        registerScrollView.addSubview(genderTitleLable)
        registerScrollView.addSubview(genderTextView)
        registerScrollView.addSubview(birthdayTitleLable)
        registerScrollView.addSubview(birthdayTextView)
        registerScrollView.addSubview(confirmButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        registerScrollView.addGestureRecognizer(tapGesture)
        
        confirmButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        genderPickerview.dataSource = self
        genderPickerview.delegate = self
        birthdayDatePicker.addTarget(self, action: #selector(dateSelectChange), for: .valueChanged)
        
        genderTextView.inputView = genderPickerview
        birthdayTextView.inputView = birthdayDatePicker
        
        configureUI()
        bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerScrollView.frame = view.bounds
        registerScrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height * 1.01)
        gradientLayer.frame = CGRect(origin: .zero, size: registerScrollView.contentSize)
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
            let loadVC = UINavigationController(rootViewController: ReloadViewController())
            loadVC.modalPresentationStyle = .fullScreen
            self?.present(loadVC, animated: false)
        }
        .store(in: &cancellables)
        
        viewModel.$error.sink { [weak self] errorString in
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
    
    @objc private func dateSelectChange(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthdayTextView.text = formatter.string(from: birthdayDatePicker.date)
        viewModel.birthdayText = birthdayTextView.text
        viewModel.checkAuthText()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - UI Setup
    private func configureUI(){
        NSLayoutConstraint.activate([
            emailTitleLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTitleLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTitleLable.topAnchor.constraint(equalTo: registerScrollView.topAnchor),
            emailTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextView.leadingAnchor.constraint(equalTo: emailTitleLable.leadingAnchor),
            emailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextView.topAnchor.constraint(equalTo: emailTitleLable.bottomAnchor),
            emailTextView.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTitleLable.leadingAnchor.constraint(equalTo: emailTitleLable.leadingAnchor),
            passwordTitleLable.trailingAnchor.constraint(equalTo: emailTitleLable.trailingAnchor),
            passwordTitleLable.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 1),
            passwordTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextView.leadingAnchor.constraint(equalTo: emailTextView.leadingAnchor),
            passwordTextView.trailingAnchor.constraint(equalTo: emailTextView.trailingAnchor),
            passwordTextView.topAnchor.constraint(equalTo: passwordTitleLable.bottomAnchor),
            passwordTextView.heightAnchor.constraint(equalToConstant: 40),
            
            passwordCheckTitleLable.leadingAnchor.constraint(equalTo: emailTitleLable.leadingAnchor),
            passwordCheckTitleLable.trailingAnchor.constraint(equalTo: emailTitleLable.trailingAnchor),
            passwordCheckTitleLable.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor, constant: 1),
            passwordCheckTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            passwordCheckTextView.leadingAnchor.constraint(equalTo: emailTextView.leadingAnchor),
            passwordCheckTextView.trailingAnchor.constraint(equalTo: emailTextView.trailingAnchor),
            passwordCheckTextView.topAnchor.constraint(equalTo: passwordCheckTitleLable.bottomAnchor),
            passwordCheckTextView.heightAnchor.constraint(equalToConstant: 40),
            
            firstNameTitleLable.leadingAnchor.constraint(equalTo: passwordCheckTextView.leadingAnchor),
            firstNameTitleLable.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            firstNameTitleLable.topAnchor.constraint(equalTo: passwordCheckTextView.bottomAnchor),
            firstNameTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            firstNameTextView.leadingAnchor.constraint(equalTo: passwordCheckTextView.leadingAnchor),
            firstNameTextView.trailingAnchor.constraint(equalTo: passwordCheckTextView.centerXAnchor, constant: -10),
            firstNameTextView.topAnchor.constraint(equalTo: firstNameTitleLable.bottomAnchor, constant: 1),
            firstNameTextView.heightAnchor.constraint(equalToConstant: 40),
            
            lastNameTitleLable.leadingAnchor.constraint(equalTo: passwordCheckTextView.centerXAnchor, constant: 10),
            lastNameTitleLable.trailingAnchor.constraint(equalTo: passwordCheckTextView.trailingAnchor),
            lastNameTitleLable.topAnchor.constraint(equalTo: firstNameTitleLable.topAnchor),
            lastNameTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            lastNameTextView.leadingAnchor.constraint(equalTo: passwordCheckTextView.centerXAnchor, constant: 10),
            lastNameTextView.trailingAnchor.constraint(equalTo: passwordCheckTextView.trailingAnchor),
            lastNameTextView.topAnchor.constraint(equalTo: firstNameTextView.topAnchor),
            lastNameTextView.heightAnchor.constraint(equalToConstant: 40),
            
            genderTitleLable.leadingAnchor.constraint(equalTo: firstNameTitleLable.leadingAnchor),
            genderTitleLable.trailingAnchor.constraint(equalTo: firstNameTitleLable.trailingAnchor),
            genderTitleLable.topAnchor.constraint(equalTo: firstNameTextView.bottomAnchor, constant: 1),
            genderTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            genderTextView.leadingAnchor.constraint(equalTo: genderTitleLable.leadingAnchor),
            genderTextView.trailingAnchor.constraint(equalTo: genderTitleLable.trailingAnchor),
            genderTextView.topAnchor.constraint(equalTo: genderTitleLable.bottomAnchor, constant: 1),
            genderTextView.heightAnchor.constraint(equalToConstant: 35),
            
            birthdayTitleLable.leadingAnchor.constraint(equalTo: lastNameTitleLable.leadingAnchor),
            birthdayTitleLable.trailingAnchor.constraint(equalTo: lastNameTitleLable.trailingAnchor),
            birthdayTitleLable.topAnchor.constraint(equalTo: genderTitleLable.topAnchor),
            birthdayTitleLable.heightAnchor.constraint(equalToConstant: 40),
            
            birthdayTextView.leadingAnchor.constraint(equalTo: lastNameTextView.leadingAnchor),
            birthdayTextView.trailingAnchor.constraint(equalTo: lastNameTextView.trailingAnchor),
            birthdayTextView.topAnchor.constraint(equalTo: genderTextView.topAnchor),
            birthdayTextView.heightAnchor.constraint(equalToConstant: 35),
            
            confirmButton.leadingAnchor.constraint(equalTo: firstNameTextView.centerXAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: lastNameTextView.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: genderTextView.bottomAnchor, constant: 20),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

}


// MARK: - Extension
extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextView.text = genderData[row]
        viewModel.genderText = genderTextView.text
        viewModel.checkAuthText()
    }
}
