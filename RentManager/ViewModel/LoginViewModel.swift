//
//  LoginViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation
import SwiftUI

@Observable
class LoginViewModel {
    
    private let userService = UsersService()
    
    func login(email: String, password: String) async -> Users? {
        do {
            
            let users = try await userService.fetchUsers()
            
            if let user = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
                if user.password == password {
                    return user
                } else {
                    print("Password salah")
                    return nil
                }
            }
            else {
                print("User tidak ditemukan")
                return nil
            }
        }
        catch {
            print("Error fetch users: \(error.localizedDescription)")
            return nil
        }
    }
}
