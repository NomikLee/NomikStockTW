//
//  FirestoreViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/2.
//

import Foundation
import Combine
import UIKit
import FirebaseAuth

class FirestoreViewModels: ObservableObject {
    
    @Published var mainDatas: UserProfileModels?
    @Published var emailData: String?
    @Published var uploadURL: String? = nil
    @Published var userImage: UIImage? = nil
    @Published var ImagePath: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func uploadImage(_ image: UIImage) {
        let path = "images/\(UUID().uuidString).jpg"
        updateMainImagePath(path)
        StorageManager.shared.uploadImage(image, path: path).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    PublisherManerger.shared.logoImageChangePublisher.send()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] url in
                self?.uploadURL = url
            })
            .store(in: &cancellables)
        downloadImage(from: path)
    }
    
    private func updateMainImagePath(_ path: String){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.updateImagePath(from: uid, with: path).receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] in
                print("照片路徑更新完成")
            }
            .store(in: &cancellables)
    }
    
    func downloadImage(from path: String) {
        StorageManager.shared.downloadImage(from: path).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] data in
                if let image = UIImage(data: data) {
                    self?.userImage = image
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchUserAuthInfo() {
        FirestoreManager.shared.getUserAuthEmail().receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] email in
                self?.emailData = email
            }
            .store(in: &cancellables)
    }
        
    func fetchFirestoreMainData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.getMainDocument(from: uid).receive(on: DispatchQueue.main)
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
                    imagePath: data["imagePath"] as? String ?? "",
                    favorites: data["favorites"] as? [String] ?? [],
                    treasury: data["treasury"] as? [String: [String]] ?? [:],
                    list: data["list"] as? [String: [String]] ?? [:]
                )
            }
            .store(in: &cancellables)
    }
    
    func updateTreasuryData(with treasuryData: [String: [String]]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.updateTreasury(from: uid, with: treasuryData).receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                print("Treasury更新完成")
            }
            .store(in: &cancellables)
    }
    
    func updateListData(with listData: [String: [String]]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.updateList(from: uid, with: listData).receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                print("List更新完成")
            }
            .store(in: &cancellables)
    }
    
    func updateMoneyData(with money: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        FirestoreManager.shared.updateMoney(from: uid, money: money).receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                print("總資產更新完成")
            }
            .store(in: &cancellables)
    }
}


