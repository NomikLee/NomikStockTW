//
//  ReloadViewController.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/10.
//

import UIKit

class ReloadViewController: UIViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Components
    private let welcomeLoadLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 40, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let welcomeBgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bg3")
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(welcomeBgImageView)
        welcomeBgImageView.addSubview(welcomeLoadLabel)
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.reloadData()
        }
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        welcomeBgImageView.frame = view.bounds
    }
    
    // MARK: - Functions
    private func reloadData() {
        let vc = TabbarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    // MARK: - Selectors
    // MARK: - UI Setup
    private func configureUI() {
        NSLayoutConstraint.activate([
            welcomeLoadLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLoadLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLoadLabel.widthAnchor.constraint(equalToConstant: 200),
            welcomeLoadLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
// MARK: - Extension
