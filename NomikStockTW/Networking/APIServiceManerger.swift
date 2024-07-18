//
//  APIServiceManerger.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import Foundation

struct APIServiceManerger {
    
    // MARK: - Variables
    static let shared = APIServiceManerger()
    
    // MARK: - Functions
    
    //Get上漲排行數據
    func getSnapshotUPMovers(completion: @escaping ((Result<SnapshotRankModels, Error>) -> Void)) {
        
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotMovers.valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "direction", value: "up"),
            URLQueryItem(name: "change", value: "value")
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let moveruUpDatas = try JSONDecoder().decode(SnapshotRankModels.self, from: data)
                completion(.success(moveruUpDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    //Get下跌排行數據
    func getSnapshotDownMovers(completion: @escaping(Result<SnapshotRankModels, Error>) -> Void) {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotMovers.valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "direction", value: "down"),
            URLQueryItem(name: "change", value: "value")
        ]
        
        urlComponents?.queryItems = queryItem
        
        guard let url = urlComponents?.url else { return }
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let moveruUpDatas = try JSONDecoder().decode(SnapshotRankModels.self, from: data)
                completion(.success(moveruUpDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    //Get成交量排行
    func getSnapshotVolumeActives(completion: @escaping(Result<SnapshotRankModels, Error>) -> Void) {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotActives.valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "trade", value: "volume")
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let volumeActivesDatas = try JSONDecoder().decode(SnapshotRankModels.self, from: data)
                completion(.success(volumeActivesDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    //Get成交值排行
    func getSnapshotValueActives(completion: @escaping(Result<SnapshotRankModels, Error>) -> Void) {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotActives.valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "trade", value: "value")
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let valueActivesDatas = try JSONDecoder().decode(SnapshotRankModels.self, from: data)
                completion(.success(valueActivesDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    //Get即時數據
    func getIntradayQuote(symbol: String, completion: @escaping(Result<IntradayQuoteModels, Error>) -> Void) {
        var url = URL(string: APIConstants.baseURL + Endpoints.intradayQuote(symbol).valueEndpoints())
        
        var request = URLRequest(url: url!)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        let tast = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let intradayQuoteDatas = try JSONDecoder().decode(IntradayQuoteModels.self, from: data)
                completion(.success(intradayQuoteDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    //Get k棒數據
    func getCandlesData(symbol: String, timeframe: String, completion: @escaping(Result<IntradayCandlesModels, Error>) -> Void) {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.intradayCandles(symbol).valueEndpoints())
        
        var queryItems = [
            URLQueryItem(name: "timeframe", value: timeframe)
        ]
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let intradayCandlesDatas = try JSONDecoder().decode(IntradayCandlesModels.self, from: data)
                completion(.success(intradayCandlesDatas))
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
