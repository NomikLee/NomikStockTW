//
//  APIConstants.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import Foundation

struct APIConstants {
    static let apiKey = "YjRlMzVjMDItMTU1OC00MzJlLThlYjMtZjI0MGZlNjIzNGIyIDliYzg3NmI3LWJkNWQtNDUwMS1iZGNhLWMzOWE1NDJlNDMzNA=="
    static let baseURL = "https://api.fugle.tw/marketdata/v1.0/stock"
}

enum Header: String {
    case apiKey = "X-API-KEY"
}

enum Endpoints {
    case snapshotMovers
    case snapshotActivesVolume
    case snapshotActivesValue
    case historicalCandles(String)
    case intradayCandles(String)
    case intradayTicker(String)
    
    func valueEndpoints() -> String {
        switch self {
        case .snapshotMovers:
            return "/snapshot/movers/TSE"
        case .snapshotActivesVolume:
            return "/snapshot/actives/TSE"
        case .snapshotActivesValue:
            return "/snapshot/actives/TSE"
        case .historicalCandles(let stockNum):
            return "/historical/candles/\(stockNum)"
        case .intradayCandles(let stockNum):
            return "/intraday/candles/\(stockNum)"
        case .intradayTicker(let stockNum):
            return "/intraday/ticker/\(stockNum)"
        }
    }
}
