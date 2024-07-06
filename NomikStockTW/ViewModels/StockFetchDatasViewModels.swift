//
//  SnapshotMoversViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/6.
//

import Foundation
import Combine

class StockFetchDatasViewModels: ObservableObject {
    
    // MARK: - Variables
    @Published var moversUPDatas: SnapshotMoversModels?
    @Published var moversDOWNDatas: SnapshotMoversModels?
    
    // MARK: - Functions
    func moversUPFetchDatas() {
        APIServiceManerger.shared.getSnapshotUPMovers { [weak self] result in
            switch result {
            case .success(let resultUPDatas):
                DispatchQueue.main.async {
                    self?.moversUPDatas = resultUPDatas
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func moversDOWNFetchDatas() {
        APIServiceManerger.shared.getSnapshotDownMovers { [weak self] result in
            switch result {
            case .success(let resultDOWNDatas):
                DispatchQueue.main.async {
                    self?.moversDOWNDatas = resultDOWNDatas
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
