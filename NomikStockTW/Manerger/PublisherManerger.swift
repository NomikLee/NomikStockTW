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
    var tradelistPublisher = CurrentValueSubject<[String], Never>([])
    var favoriteRefresh = PassthroughSubject<Void, Never>()
    
}
