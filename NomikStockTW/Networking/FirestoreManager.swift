//
//  FirestoreManager.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/2.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

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
                        if existingDatas[key]?[2] == "0" {
                            print("刪除")
                        }
                        break
                    }
                    
                    let flatNumbers = existingDatas.filter{ $0.value.contains(value[0]) }
                    if flatNumbers == [:]  {
                        let addkey = Int(existingDatas.keys.sorted().last ?? "")
                        if addkey == nil {
                            existingDatas["1"] = value
                        } else {
                            existingDatas["\(addkey! + 1)"] = value
                        }
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
                    let addkey = Int(existingListDatas.keys.sorted().last ?? "")
                    if addkey == nil || addkey == 0 {
                        existingListDatas["0"] = value
                    }else {
                        let addnum = (addkey ?? 0) + 1
                        existingListDatas["\(addnum)"] = value
                    }
                    
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
    
    //更新總資產
    func updateMoney(from documentID: String, money: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
                self.db.collection("users").document(documentID).setData(["money": money], merge: true) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
