//
//  LoginViewModels.swift
//  NomikStockTW
//
//  Created by Pinocchio on 2024/7/27.
//

import Foundation
import Combine

final class LoginViewModels: ObservableObject {
    @Published var loginEmailText: String?
    @Published var loginPasswordText: String?
    @Published var isCheckLoginValid: Bool = false
    
    func checkLoginValid() {
        guard let loginEmailText = loginEmailText, let loginPasswordText = loginPasswordText else {
            isCheckLoginValid = false
            return
        }
        
        isCheckLoginValid = isValidEmail(loginEmailText) && loginPasswordText.count >= 8
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
