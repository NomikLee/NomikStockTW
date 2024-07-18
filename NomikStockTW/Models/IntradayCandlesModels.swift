//
//  IntradayCandlesModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/18.
//

import Foundation

struct IntradayCandlesModels: Codable {
    let date: String
    let symbol: String
    let data: [CandlesData]
}

struct CandlesData: Codable {
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    let average: Double
}
