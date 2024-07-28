//
//  RegisterViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/21.
//

import Foundation
import Combine
import Firebase

final class AuthViewModels: ObservableObject {
    @Published var emailText: String?
    @Published var passwordText: String?
    @Published var passwordCheckText: String?
    @Published var firstNameText: String?
    @Published var lastNameText: String?
    @Published var isAuthValid: Bool = false
    @Published var user: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    func checkAuthText() {
        guard let emailText = emailText, let passwordText = passwordText, let passwordCheckText = passwordCheckText, let firstNameText = firstNameText, !firstNameText.isEmpty, let lastNameText = lastNameText, !lastNameText.isEmpty else {
            isAuthValid = false
            return
        }
        
        isAuthValid = isValidEmail(emailText) && passwordText.count >= 8 && passwordCheckText == passwordText
    }
    
    func checkLoginAuthText() {
        guard let emailText = emailText, let passwordText = passwordText else {
            isAuthValid = false
            return
        }
        
        isAuthValid = isValidEmail(emailText) && passwordText.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser() {
        guard let email = emailText, let password = passwordText else { return }
        
        AuthManager.shared.registerUser(with: email, password: password).sink { _ in
            
        } receiveValue: { [weak self] user in
            self?.user = user
        }
        .store(in: &cancellables)
    }
    
    func loginUser() {
        guard let email = emailText, let password = passwordText else { return }
        
        AuthManager.shared.loginUser(with: email, password: password).sink { _ in
            
        } receiveValue: { [weak self] user in
            self?.user = user
        }
        .store(in: &cancellables)
    }
}
