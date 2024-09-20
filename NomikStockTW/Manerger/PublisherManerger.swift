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
    
    //股市排行榜選擇 Publisher
    var selectionPublisher = PassthroughSubject<SelectionType, Never>()
    
    //自選股Refresh Publisher
    var favoriteRefreshPublisher = PassthroughSubject<Void, Never>()
    
    //登出按鈕 Publisher
    var signOutButtonTapPublisher = PassthroughSubject<Void, Never>()
    
    //進入使用者設資訊 Publisher
    var userHeaderImageTapPublisher = PassthroughSubject<Void, Never>()
    
    //進入自選股cell Publisher
    var pushOptionalStockCollectionCell = PassthroughSubject<String, Never>()
    
    //進入排行榜cell Publisher
    var pushStockRankCollectionCell = PassthroughSubject<String, Never>()
    
    //使用者照片更改 Publisher
    var logoImageChangePublisher = PassthroughSubject<Void, Never>()
    
    //更新使用者總資產 Publisher
    var updateTotelMoneyPublisher = PassthroughSubject<Void, Never>()
}
