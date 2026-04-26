//
//  LoginViewModel.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import Foundation
import Supabase

@Observable
class LoginViewModel {
    
    // 🔐 LOGIN
    func login(email: String, password: String) async -> Users? {
        do {
            let response = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            let user = response.user
            
            let result: [Users] = try await supabase
                .from("users")
                .select()
                .eq("id", value: user.id.uuidString)
                .execute()
                .value
            
            return result.first
            
        } catch {
            print("Login gagal: \(error.localizedDescription)")
            return nil
        }
    }
    
    // 📝 REGISTER
    func register(email: String, password: String) async -> Bool {
        do {
            let response = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            let user = response.user
            
            try await supabase
                .from("users")
                .insert([
                    "id": user.id.uuidString,
                    "email": email
                ])
                .execute()
            
            return true
            
        } catch {
            print("Register gagal: \(error.localizedDescription)")
            return false
        }
    }
    
    // ✅ VALIDASI REGISTER
    func validateRegister(
        email: String,
        password: String,
        confirmPassword: String
    ) -> String? {
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty {
            return "All fields must be filled"
        }
        
        if !email.contains("@") {
            return "Invalid email format"
        }
        
        if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        
        if password != confirmPassword {
            return "Password does not match"
        }
        
        return nil
    }
    
    // ✅ VALIDASI LOGIN
    func validateLogin(email: String, password: String) -> String? {
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.isEmpty {
            return "Email and password must be filled"
        }
        
        return nil
    }
}
