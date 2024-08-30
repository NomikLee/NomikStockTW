//
//  APIServiceManerger.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import Foundation
import Combine

struct APIServiceManerger {
    
    // MARK: - Variables
    static let shared = APIServiceManerger()
    
    // MARK: - Functions
    
    //Get上漲排行數據
    func getSnapshotUPMovers() -> AnyPublisher<SnapshotRankModels, Error> {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotMovers.valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "direction", value: "up"),
            URLQueryItem(name: "change", value: "value")
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: SnapshotRankModels.self, decoder: JSONDecoder())
            .mapError{ error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
    
    //Get下跌排行數據
    func getSnapshotDownMovers() -> AnyPublisher<SnapshotRankModels, Error> {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotMovers.valueEndpoints())
        
        let queryItem = [
            URLQueryItem(name: "direction", value: "down"),
            URLQueryItem(name: "change", value: "value")
        ]
        
        urlComponents?.queryItems = queryItem
        
        guard let url = urlComponents?.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: SnapshotRankModels.self, decoder: JSONDecoder())
            .mapError{ error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
    
    //Get成交量排行
    func getSnapshotVolumeActives() -> AnyPublisher<SnapshotRankModels, Error> {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotActives.valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "trade", value: "volume")
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: SnapshotRankModels.self, decoder: JSONDecoder())
            .mapError { error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
    
    //Get成交值排行
    func getSnapshotValueActives() -> AnyPublisher<SnapshotRankModels, Error> {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.snapshotActives.valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "trade", value: "value")
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: SnapshotRankModels.self, decoder: JSONDecoder())
            .mapError { error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
    
    //Get即時數據
    func getIntradayQuote(symbol: String) -> AnyPublisher<IntradayQuoteModels, Error> {
        var url = URL(string: APIConstants.baseURL + Endpoints.intradayQuote(symbol).valueEndpoints())
        
        var request = URLRequest(url: url!)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: IntradayQuoteModels.self, decoder: JSONDecoder())
            .mapError { error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
    
    //Get k棒數據
    func getCandlesData(symbol: String, timeframe: String) -> AnyPublisher<IntradayCandlesModels, Error> {
        var urlComponents = URLComponents(string: APIConstants.baseURL + Endpoints.intradayCandles(symbol).valueEndpoints())
        
        let queryItems = [
            URLQueryItem(name: "timeframe", value: timeframe)
        ]
        
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        
        var request = URLRequest(url: url)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: IntradayCandlesModels.self, decoder: JSONDecoder())
            .mapError { error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
    
    //Get自選股即時數據
    func getFavoritesIntradayQuote(symbol: String) -> AnyPublisher<IntradayQuoteModels, Error> {
        let url = URL(string: APIConstants.baseURL + Endpoints.intradayQuote(symbol).valueEndpoints())
        
        var request = URLRequest(url: url!)
        request.setValue(APIConstants.apiKey, forHTTPHeaderField: Header.apiKey.rawValue)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: IntradayQuoteModels.self, decoder: JSONDecoder())
            .mapError { error in
                return error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
}
