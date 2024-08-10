//
//  FirestoreManager.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/8/2.
//

import Foundation
import FirebaseFirestore
import Combine

class FirestoreManager {
    
    // MARK: - Variables
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    // MARK: - Functions
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
    
    func getSubCollection(from userId: String, collectionName: String) -> AnyPublisher<[QueryDocumentSnapshot], Error> {
        return Future { promise in
            self.db.collection("users").document(userId).collection(collectionName).getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(error))
                }else {
                    if let documents = querySnapshot?.documents {
                        promise(.success(documents))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
