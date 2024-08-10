//
//  AuthManerger.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/28.
//

import Foundation
import Combine
import Firebase
import FirebaseAuthCombineSwift

class AuthManager {
    static let shared = AuthManager()
    
    func registerUser(with email: String, password: String, gender: String, birthday: String, firstName: String, lastName: String) -> AnyPublisher<User, Error> {
        return Auth.auth().createUser(withEmail: email, password: password)
            .map { $0.user }
            .handleEvents(receiveOutput: { user in
                self.userInfoSave(uid: user.uid, gender: gender, birthday: birthday, firstName: firstName, lastName: lastName)
            })
            .eraseToAnyPublisher()
    }
    
    func userInfoSave(uid: String, gender: String, birthday: String, firstName: String, lastName: String) {
        let db = Firestore.firestore()
        
        var userMainInfo = db.collection("users").document(uid)
        userMainInfo.setData(["uid" : uid, "gender" : gender, "birthday" : birthday, "firstName" : firstName, "lastName" : lastName, "moneny": 1500000]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        var userFavoriteInfo = userMainInfo.collection("favorites").document()
        userFavoriteInfo.setData([
            "00631L": "正2"
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        var userTreasuryInfo = userMainInfo.collection("treasury").document()
        userTreasuryInfo.setData([
            "00631L" : 1
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        var userTradingRecordInfo = userMainInfo.collection("tradingRecord").document()
        userTradingRecordInfo.setData([
            "00631L" : [1, 220]
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loginUser(with email: String, password: String) ->AnyPublisher<User, Error> {
        return Auth.auth().signIn(withEmail: email, password: password).map(\.user).eraseToAnyPublisher()
    }
}
