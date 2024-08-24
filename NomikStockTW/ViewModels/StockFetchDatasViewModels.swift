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
    @Published var favoritesIntradayQuoteDatas: IntradayQuoteModels?
    @Published var inventoryIntradayQuoteDatas: IntradayQuoteModels?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functions
    func moversUPFetchDatas() {
        APIServiceManerger.shared.getSnapshotUPMovers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] moversUPData in
                self?.moversUPDatas = moversUPData
            }
            .store(in: &cancellables)
    }
    
    func moversDOWNFetchDatas() {
        APIServiceManerger.shared.getSnapshotDownMovers()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] moversDOWNData in
                self?.moversDOWNDatas = moversDOWNData
            }
            .store(in: &cancellables)
    }
    
    func volumeActivesFetchDatas(){
        APIServiceManerger.shared.getSnapshotVolumeActives()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] volumeActivesData in
                self?.volumeActivesDatas = volumeActivesData
            }
            .store(in: &cancellables)
    }
    
    func valueActivesFetchDatas(){
        APIServiceManerger.shared.getSnapshotValueActives()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] valueActivesData in
                self?.valueActivesDatas = valueActivesData
            }
            .store(in: &cancellables)
    }
    
    func intradayQuoteFetchDatas(with symbol: String){
        APIServiceManerger.shared.getIntradayQuote(symbol: symbol)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] intradayQuoteData in
                self?.intradayQuoteDatas = intradayQuoteData
            }
            .store(in: &cancellables)
    }
    
    func intradayCandlesFetchDatas(with symbol: String, timeframe: String){
        APIServiceManerger.shared.getCandlesData(symbol: symbol, timeframe: timeframe)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] intradayCandlesData in
                self?.intradayCandlesDatas = intradayCandlesData
            }
            .store(in: &cancellables)
    }
    
    func favoritesIntradayQuoteFetchDatas(with symbol: String){
        APIServiceManerger.shared.getFavoritesIntradayQuote(symbol: symbol)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] favoritesIntradayQuoteData in
                self?.favoritesIntradayQuoteDatas = favoritesIntradayQuoteData
            }
            .store(in: &cancellables)
    }
    
    func inventoryIntradayQuoteFetchDatas(with symbol: String){
        APIServiceManerger.shared.getInventoryIntradayQuote(symbol: symbol)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] inventoryIntradayQuoteData in
                self?.inventoryIntradayQuoteDatas = inventoryIntradayQuoteData
            }
            .store(in: &cancellables)
    }
}
