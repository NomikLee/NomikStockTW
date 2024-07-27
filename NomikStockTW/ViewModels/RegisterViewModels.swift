//
//  RegisterViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/21.
//

import Foundation
import Combine

final class RegisterViewModels: ObservableObject {
    @Published var emailText: String?
    @Published var passwordText: String?
    @Published var passwordCheckText: String?
    @Published var firstNameText: String?
    @Published var lastNameText: String?
    @Published var isRegisterValid: Bool = false
    
    func checkRegisterText() {
        guard let emailText = emailText, let passwordText = passwordText, let passwordCheckText = passwordCheckText, let firstNameText = firstNameText, !firstNameText.isEmpty, let lastNameText = lastNameText, !lastNameText.isEmpty else {
            isRegisterValid = false
            return
        }
        
        isRegisterValid = isValidEmail(emailText) && passwordText.count >= 8 && passwordCheckText == passwordText
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
