//
//  UserSettingViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/10.
//

import UIKit

protocol logoutDelegate: AnyObject {
    func logoutButtonTap()
}

class UserSettingViewController: UIViewController {
    
    // MARK: - Variables
    weak var delegate: logoutDelegate?
    
    // MARK: - UI Components
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let userNameUILabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "李糯米"
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
        
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: - Selectors
    @objc private func logoutButtonTapped() {
        delegate?.logoutButtonTap()
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
            userNameUILabel.widthAnchor.constraint(equalToConstant: 100),
            userNameUILabel.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoutButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    // MARK: - Extension

}
