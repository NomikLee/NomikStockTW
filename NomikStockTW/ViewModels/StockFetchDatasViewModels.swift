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
    @Published var moversUPDatas: SnapshotRankModels?
    @Published var moversDOWNDatas: SnapshotRankModels?
    @Published var volumeActivesDatas: SnapshotRankModels?
    @Published var valueActivesDatas: SnapshotRankModels?
    
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
    
    func volumeActivesFetchDatas(){
        APIServiceManerger.shared.getSnapshotVolumeActives { [weak self] result in
            switch result {
            case .success(let volumeActivesDatas):
                DispatchQueue.main.async {
                    self?.volumeActivesDatas = volumeActivesDatas
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func valueActivesFetchDatas(){
        APIServiceManerger.shared.getSnapshotValueActives { [weak self] result in
            switch result {
            case .success(let valueActivesDatas):
                DispatchQueue.main.async {
                    self?.valueActivesDatas = valueActivesDatas
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
