//
//  FirestoreManager.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/2.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

class FirestoreManager {
    
    // MARK: - Variables
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    // MARK: - Functions
    //取用使用者email管理器
    func getUserAuthEmail() -> AnyPublisher<String, Error> {
        return Future { promise in
            if let email = Auth.auth().currentUser?.email {
                promise(.success(email))
            }else {
                promise(.failure(Error.self as! Error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    //取用主要資料管理器
    func getMainDocument(from documentID: String) -> AnyPublisher<DocumentSnapshot?, Error> {
        return Future { promise in
            self.db.collection("users").document(documentID).getDocument { doc, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(doc))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //更新庫存管理器
    func updateImagePath(from documentID: String, with imagePath: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.db.collection("users").document(documentID).updateData(["imagePath":imagePath]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //更新庫存管理器
    func updateTreasury(from documentID: String, with treasuryData: [String: [String]]) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.db.collection("users").document(documentID).getDocument { doc, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                var existingDatas = doc?.data()?["treasury"] as? [String: [String]] ?? [:]
                
                for (_, value) in treasuryData {
                    for (key, data) in existingDatas where data[0] == value[0] {
                        existingDatas[key]?[2] = "\(Int(value[2])! + Int(data[2])!)"
                        break
                    }
                    
                    let flatNumbers = existingDatas.filter{ $0.value.contains(value[0]) }
                    if flatNumbers == [:] {
                        var addkey = Int(existingDatas.keys.sorted().last!)
                        existingDatas["\(addkey! + 1)"] = value
                    }
                }
    
                self.db.collection("users").document(documentID).setData(["treasury": existingDatas], merge: true) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //更新交易紀錄管理器
    func updateList(from documentID: String, with listData: [String: [String]]) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.db.collection("users").document(documentID).getDocument { doc, error in
                if let error = error {
                    promise(.failure(error))
                }
                
                var existingListDatas = doc?.data()?["list"] as? [String: [String]] ?? [:]
                
                for (_, value) in listData {
                    var addkey = Int(existingListDatas.keys.sorted().last!)
                    existingListDatas["\(addkey! + 1)"] = value
                    
                    self.db.collection("users").document(documentID).setData(["list": existingListDatas], merge: true) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
