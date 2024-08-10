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
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(welcomeLoadLabel)
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.reloadData()
        }
        
        configureUI()
    }
    
    // MARK: - Functions
    private func reloadData() {
        let vc = TabbarViewController()
        navigationController?.pushViewController(vc, animated: false)
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
