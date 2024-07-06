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
    func getSnapshotUPMovers(completion: @escaping ((Result<SnapshotMoversModels, Error>) -> Void)) {
        
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
                let moveruUpDatas = try JSONDecoder().decode(SnapshotMoversModels.self, from: data)
                completion(.success(moveruUpDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
    
    //Get下跌排行數據
    func getSnapshotDownMovers(completion: @escaping(Result<SnapshotMoversModels, Error>) -> Void) {
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
                let moveruUpDatas = try JSONDecoder().decode(SnapshotMoversModels.self, from: data)
                completion(.success(moveruUpDatas))
            }catch {
                completion(.failure(error))
            }
        }
        tast.resume()
    }
}
