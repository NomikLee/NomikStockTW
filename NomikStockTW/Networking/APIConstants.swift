//
//  APIConstants.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/3.
//

import Foundation

struct APIConstants {
    static let apiKey = ""
    static let baseURL = "https://api.fugle.tw/marketdata/v1.0/stock"
}

enum Header: String {
    case apiKey = "X-API-KEY"
}

enum Endpoints {
    case snapshotMovers
    case snapshotActives
    case historicalCandles(String)
    case intradayQuote(String)
    case intradayCandles(String)
    case intradayTicker(String)
    
    func valueEndpoints() -> String {
        switch self {
        case .snapshotMovers:
            return "/snapshot/movers/TSE"
        case .snapshotActives:
            return "/snapshot/actives/TSE"
        case .historicalCandles(let stockNum):
            return "/historical/candles/\(stockNum)"
        case .intradayCandles(let stockNum):
            return "/intraday/candles/\(stockNum)"
        case .intradayTicker(let stockNum):
            return "/intraday/ticker/\(stockNum)"
        case .intradayQuote(let stockNum):
            return "/intraday/quote/\(stockNum)"
        }
    }
}
