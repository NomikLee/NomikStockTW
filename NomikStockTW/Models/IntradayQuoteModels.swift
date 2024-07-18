//
//  IntradayQuoteModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/16.
//

import Foundation

struct IntradayQuoteModels: Codable {
    let date: String
    let symbol: String
    let name: String
    let openPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let closePrice: Double
    let avgPrice: Double
    let change: Double
    let changePercent: Double
    let amplitude: Double
    let lastPrice: Double
    let lastSize: Double
    let total: totalData
}
    
struct totalData: Codable {
    let tradeValue: Double
    let tradeVolume: Double
    let tradeVolumeAtBid: Double
    let tradeVolumeAtAsk: Double
}
