//
//  UserSettingViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/10.
//

import UIKit
import Combine

protocol logoutDelegate: AnyObject {
    func logoutButtonTap()
}

class UserSettingViewController: UIViewController {
    
    // MARK: - Variables
    private var viewModel = FirestoreViewModels()
    weak var delegate: logoutDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let userNameUILabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "---"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let userbirthdayTitleUILabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "生日"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .systemBrown
        return label
    }()
    
    private let userbirthdayUILabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--- --, ----"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let userEmailTitleUILabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .systemBrown
        return label
    }()
    
    private let userEmailUILabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "----@gmail.com"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        view.addSubview(userImageView)
        view.addSubview(userNameUILabel)
        view.addSubview(logoutButton)
        view.addSubview(userbirthdayTitleUILabel)
        view.addSubview(userbirthdayUILabel)
        view.addSubview(userEmailTitleUILabel)
        view.addSubview(userEmailUILabel)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        configureUI()
        bindView()
        tapGesture()
    }
    
    // MARK: - Functions
    private func bindView() {
        
        viewModel.fetchUserAuthInfo()
        viewModel.fetchFirestoreMainData()
        
        let path = "images/486298C6-9A7E-4116-8B97-51032F151D09.jpg"
        viewModel.downloadImage(from: path)
        
        viewModel.$emailData.receive(on: DispatchQueue.main)
            .sink { [weak self] email in
                self?.userEmailUILabel.text = email
            }
            .store(in: &cancellables)
        
        viewModel.$mainDatas.receive(on: DispatchQueue.main)
            .sink { [weak self] infoDatas in
                self?.userbirthdayUILabel.text = infoDatas?.birthday
                if let firstName = infoDatas?.firstName, let lastName = infoDatas?.lastName {
                    self?.userNameUILabel.text = "\(firstName.capitalized) \(lastName.capitalized)"
                }
            }
            .store(in: &cancellables)
        
        viewModel.$userImage.receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.userImageView.image = image
            }
            .store(in: &cancellables)
    }
    
    private func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        userImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Selectors
    @objc private func logoutButtonTapped() {
        delegate?.logoutButtonTap()
    }
    
    @objc private func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 100),
            userImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameUILabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameUILabel.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor),
            userNameUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userNameUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userNameUILabel.heightAnchor.constraint(equalToConstant: 50),
            
            userbirthdayTitleUILabel.topAnchor.constraint(equalTo: userNameUILabel.bottomAnchor, constant: 20),
            userbirthdayTitleUILabel.centerXAnchor.constraint(equalTo: userNameUILabel.centerXAnchor),
            userbirthdayTitleUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userbirthdayTitleUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userbirthdayTitleUILabel.heightAnchor.constraint(equalToConstant: 50),
            
            userbirthdayUILabel.topAnchor.constraint(equalTo: userbirthdayTitleUILabel.bottomAnchor, constant: 10),
            userbirthdayUILabel.centerXAnchor.constraint(equalTo: userbirthdayTitleUILabel.centerXAnchor),
            userbirthdayUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userbirthdayUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userbirthdayUILabel.heightAnchor.constraint(equalToConstant: 40),
            
            userEmailTitleUILabel.topAnchor.constraint(equalTo: userbirthdayUILabel.bottomAnchor, constant: 20),
            userEmailTitleUILabel.centerXAnchor.constraint(equalTo: userbirthdayUILabel.centerXAnchor),
            userEmailTitleUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userEmailTitleUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userEmailTitleUILabel.heightAnchor.constraint(equalToConstant: 50),
            
            userEmailUILabel.topAnchor.constraint(equalTo: userEmailTitleUILabel.bottomAnchor, constant: 10),
            userEmailUILabel.centerXAnchor.constraint(equalTo: userEmailTitleUILabel.centerXAnchor),
            userEmailUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userEmailUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userEmailUILabel.heightAnchor.constraint(equalToConstant: 40),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            logoutButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
}

// MARK: - Extension
extension UserSettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectImage = info[.originalImage] as? UIImage {
            viewModel.uploadImage(selectImage)
            userImageView.image = selectImage
        }
        dismiss(animated: true)
    }
}
