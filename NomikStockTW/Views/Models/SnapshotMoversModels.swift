//
//  SnapshotMoversModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/6.
//

import Foundation

struct SnapshotMoversModels: Codable {
    let date: String
    let market: String
    let data: [Datas]
}

struct Datas: Codable {
    let symbol: String
    let name: String
    let openPrice: Double?
    let highPrice: Double?
    let lowPrice: Double?
    let closePrice: Double?
    let change: Double
    let changePercent: Double
    let tradeVolume: Double
    let tradeValue: Double
}
