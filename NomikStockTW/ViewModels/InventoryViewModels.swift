//
//  InventoryViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/24.
//

import Foundation

class InventoryViewModels: ObservableObject {
    @Published var totelMoney: String?
    @Published var stockValue: String?
    @Published var remainingFund: String?
    
    func totelUpdateMoney() {
    }
}
