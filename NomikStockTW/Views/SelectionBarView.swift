//
//  SelectionBarView.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/8.
//

import UIKit
import Combine

enum SelectionType {
    case up, down, volume, value
}

class SelectionBarView: UIView {
    
    // MARK: - Variables
    let selectionPublisher = PassthroughSubject<SelectionType, Never>()
    
    //didset偵測selectTap變化 只要i與selectTap相同 TitleColor與isActive 就會做三元運算走左邊數值
    private var selectTap: Int = 0 {
        didSet {
            for i in 0..<selectionButtons.count {
                UIView.animate(withDuration: 0.3, delay: 0 , options: .curveEaseInOut) { [weak self] in
                    self?.selectionButtons[i].setTitleColor((self?.selectTap == i ? .label : .secondaryLabel), for: .normal)
                    self?.leadingAnchors[i].isActive = (self?.selectTap == i ? true : false)
                    self?.trailingAnchors[i].isActive = (self?.selectTap == i ? true : false)
                    self?.layoutIfNeeded()

                }
            }
        }
    }
    
    private var selectionButtons: [UIButton] = ["上漲排行", "下跌排行", "成量排行", "成值排行"].map{ title in
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }
    
    //宣告leadingAnchors和trailingAnchors佈局的清單
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    // MARK: - UI Components
    private lazy var selectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: selectionButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private let bottomLineBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(selectionStackView)
        addSubview(bottomLineBar)
        
        configureUI()
        selectButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func selectButton() {
        for (index, button) in selectionStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else { return }
            
            
            if index == selectTap {
                button.setTitleColor(.label, for: .normal)
            } else {
                button.setTitleColor(.secondaryLabel, for: .normal)
            }
            
            button.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Selectors
    @objc private func didTapTab(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        //按鈕按下後觸發selectTap和selectionPublisher
        switch text {
        case "上漲排行":
            selectionPublisher.send(.up)
            selectTap = 0
        case "下跌排行":
            selectionPublisher.send(.down)
            selectTap = 1
        case "成量排行":
            selectionPublisher.send(.volume)
            selectTap = 2
        default:
            selectionPublisher.send(.value)
            selectTap = 3
        }
    }
        
    // MARK: - UI Setup
    private func configureUI() {
        
        //選單下方的bar的leadingAnchor和trailingAnchor 依照Button數量去儲存佈局到leadingAnchors和trailingAnchors的清單內
        for i in 0..<selectionButtons.count {
            let leadingAnchor = bottomLineBar.leadingAnchor.constraint(equalTo: selectionStackView.arrangedSubviews[i].leadingAnchor)
            let trailingAnchor = bottomLineBar.trailingAnchor.constraint(equalTo: selectionStackView.arrangedSubviews[i].trailingAnchor)
            leadingAnchors.append(leadingAnchor)
            trailingAnchors.append(trailingAnchor)
        }
        
        NSLayoutConstraint.activate([
            selectionStackView.topAnchor.constraint(equalTo: topAnchor),
            selectionStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectionStackView.heightAnchor.constraint(equalToConstant: 30),
            
            //選單下方的bar初始位置佈局
            leadingAnchors[0],
            trailingAnchors[0],
            bottomLineBar.topAnchor.constraint(equalTo: selectionStackView.arrangedSubviews[0].bottomAnchor),
            bottomLineBar.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    // MARK: - Extension
    

}
