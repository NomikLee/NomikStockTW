//
//  UserProfileModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/17.
//

import Foundation

struct UserProfileModels: Codable {
    let uid: String
    let gender: String
    let birthday: String
    let firstName: String
    let lastName: String
    let money: String
    let favorites: [String]
    let treasury: [String: [String]]
}
