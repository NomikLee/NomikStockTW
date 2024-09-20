//
//  StartedViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/20.
//

import UIKit
import FirebaseAuth

class StartedViewController: UIViewController {
    
    // MARK: - Variables
    var timer: Timer?
    var currentText: String = ""
    var fullText: String = "Are you ready with your strategy to land your great deal?"
    var currentIndex: Int = 0
    
    // MARK: - UI Components
    private let marqueeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg2")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let enterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started", for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .white
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 20
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(loginButton)
        backgroundImageView.addSubview(enterButton)
        view.addSubview(marqueeTitle)
        
        configureUI()
        setMarquee()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        applyGradientToButton()
    }
    
    // MARK: - Functions
    private func applyGradientToButton() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = enterButton.bounds
        gradientLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemPurple.cgColor]
        enterButton.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setMarquee() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateMarquee), userInfo: nil, repeats: true)
    }
    
    // MARK: - Selectors
    @objc private func didTapLogin() {
        let loginVC = LoginViewController()
        loginVC.title = "Login"
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc private func didTapRegister() {
        let registerVC = RegisterViewController()
        registerVC.title = "Register"
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func updateMarquee() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            currentText.append(fullText[index])
            marqueeTitle.text = currentText
            currentIndex += 1
        }else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        enterButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: {
            self.enterButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
        
        NSLayoutConstraint.activate([
            marqueeTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            marqueeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            marqueeTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            marqueeTitle.heightAnchor.constraint(equalToConstant: 150),
            
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 80),
            
            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            enterButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -15),
            enterButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
// MARK: - Extension
