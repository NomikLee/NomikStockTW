//
//  PublisherManerger.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/30.
//
import UIKit
import Combine

class PublisherManerger {
    
    static let shared = PublisherManerger()
    
    private init() {}
    
    var selectionPublisher = PassthroughSubject<SelectionType, Never>()
    var favoriteRefreshPublisher = PassthroughSubject<Void, Never>()
    var logoutButtonTapPublisher = PassthroughSubject<Void, Never>()
    var userHeaderImageTapPublisher = PassthroughSubject<Void, Never>()
    var pushOptionalStockCollectionCell = PassthroughSubject<String, Never>()
    var pushStockRankCollectionCell = PassthroughSubject<String, Never>()
    var logoImageChangePublisher = PassthroughSubject<Void, Never>()
    
}
