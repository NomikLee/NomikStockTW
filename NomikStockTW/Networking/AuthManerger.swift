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
    
    private func userInfoSave(uid: String, gender: String, birthday: String, firstName: String, lastName: String) {
        let db = Firestore.firestore()
        let treasuryData: [String: [String]] = [
                "0": ["0", "0", "0", "0"]
            ]
        
        let listData: [String: [String]] = [
                "0": ["0", "0", "0", "0", "0"]
            ]
        
        let userMainInfo = db.collection("users").document(uid)
        userMainInfo.setData([
            "uid" : uid,
            "imagePath" : "",
            "gender" : gender,
            "birthday" : birthday,
            "firstName" : firstName,
            "lastName" : lastName,
            "money": "2000000",
            "favorites" : ["2330"],
            "treasury" : treasuryData,
            "list" : listData
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
