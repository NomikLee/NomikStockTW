//
//  FirestoreViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/2.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class FirestoreViewModels: ObservableObject {
    @Published var mainDatas: [String: Any] = [:]
    @Published var favoritesDatas: [[String: Any]] = []
    
    private var cancellables = Set<AnyCancellable>()
        
    func fetchFirestoreMainData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.getMainDocument(from: uid)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] document in
                if let mainData = document?.data() {
                    self?.mainDatas = mainData
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchFavoritesCollection() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.getSubCollection(from: uid, collectionName: "favorites")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] documents in
                let favoritesData = documents.map { $0.data() }
                self?.favoritesDatas = favoritesData
            }
            .store(in: &cancellables)
    }
}
