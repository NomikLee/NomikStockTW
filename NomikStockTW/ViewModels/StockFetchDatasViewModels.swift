//
//  SnapshotMoversViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/6.
//

import Foundation
import Combine

final class StockFetchDatasViewModels: ObservableObject {
    
    // MARK: - Variables
    @Published var moversUPDatas: SnapshotRankModels?
    @Published var moversDOWNDatas: SnapshotRankModels?
    @Published var volumeActivesDatas: SnapshotRankModels?
    @Published var valueActivesDatas: SnapshotRankModels?
    @Published var intradayQuoteDatas: IntradayQuoteModels?
    @Published var intradayCandlesDatas: IntradayCandlesModels?
    
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
    
    func intradayQuoteFetchDatas(with symbol: String){
        APIServiceManerger.shared.getIntradayQuote(symbol: symbol) { [weak self] result in
            switch result {
            case .success(let intradayQuoteDatas):
                DispatchQueue.main.async {
                    self?.intradayQuoteDatas = intradayQuoteDatas
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func intradayCandlesFetchDatas(with symbol: String, timeframe: String){
        APIServiceManerger.shared.getCandlesData(symbol: symbol, timeframe: timeframe) { [weak self] result in
            switch result {
            case .success(let intradayCandlesDatas):
                DispatchQueue.main.async {
                    self?.intradayCandlesDatas = intradayCandlesDatas
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
