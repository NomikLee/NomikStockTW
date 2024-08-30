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
    func userAuthInfo() -> AnyPublisher<String, Error> {
        return Future { promise in
            if let email = Auth.auth().currentUser?.email {
                promise(.success(email))
            }else {
                promise(.failure(Error.self as! Error))
            }
        }
        .eraseToAnyPublisher()
    }
    
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
    
    func updateMainDocument(from documentID: String, with treasuryData: [String: [String]]) -> AnyPublisher<Void, Error> {
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
}
