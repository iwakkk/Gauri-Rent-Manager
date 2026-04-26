//
//  RegisterView.swift
//  RentManager
//
//  Created by Edward Suwandi on 26/04/26.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    @State private var viewModel = LoginViewModel()
    
    var body: some View {
        
        ZStack {
            Color.gauribackground.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                Text("Create Account")
                    .font(.title.bold())
                
                VStack(spacing: 16) {
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Button {
                    
                    // 🔥 VALIDASI DARI VIEWMODEL
                    if let error = viewModel.validateRegister(
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword
                    ) {
                        errorMessage = error
                        showError = true
                        return
                    }
                    
                    isLoading = true
                    
                    Task {
                        let success = await viewModel.register(
                            email: email,
                            password: password
                        )
                        
                        isLoading = false
                        
                        if success {
                            dismiss()
                        } else {
                            errorMessage = "Failed to register"
                            showError = true
                        }
                    }
                    
                } label: {
                    if isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Register")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gauriprimary)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(isLoading)
                
                Button("Back to Login") {
                    dismiss()
                }
                .font(.footnote)
                .foregroundStyle(Color.gauriprimary)
                
                Spacer()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    RegisterView()
}
