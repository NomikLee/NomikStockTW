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
    
    @Published var mainDatas: UserProfileModels?
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
                guard let data = document?.data() else { return }
                self?.mainDatas = UserProfileModels(
                    uid: data["uid"] as? String ?? "",
                    gender: data["gender"] as? String ?? "",
                    birthday: data["birthday"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    money: data["money"] as? String ?? "",
                    favorites: data["favorites"] as? [String] ?? [],
                    treasury: data["treasury"] as? [String: [String]] ?? [:]
                )
            }
            .store(in: &cancellables)
    }
    
    func updateTreasuryData(with treasuryData: [String: [String]]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.updateMainDocument(from: uid, with: treasuryData)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                print("更新完成")
            }
            .store(in: &cancellables)
    }
}
