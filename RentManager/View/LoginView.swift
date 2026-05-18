//
//  LoginView.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var viewModel = AuthViewModel()
    @State private var showRegister = false
    
    var body: some View {
        
        ZStack {
            Color.gauribackground.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    Spacer()
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Gauri Rent Manager")
                            .font(.title.bold())
                            .foregroundStyle(Color.gauriprimary)
                        
                        Text("Login to continue")
                            .font(.title2.bold())
                    }
                    
                    // Fields
                    VStack(spacing: 16) {
                        
                        TextField("Email", text: $email)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button {
                        
                        // Validate Login
                        if let error = viewModel.validateLogin(
                            email: email,
                            password: password
                        ) {
                            errorMessage = error
                            showError = true
                            return
                        }
                        
                        isLoading = true
                        
                        // Login with inserted email and password
                        Task {
                            let user = await viewModel.login(
                                email: email,
                                password: password
                            )
                            
                            isLoading = false
                            
                            // Set appstate to current user
                            if let user = user {
                                appState.currentUser = user
                            } else {
                                errorMessage = "Invalid email or password"
                                showError = true
                            }
                        }
                        
                    } label: {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Login")
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
                    
                    // Register Button
                    Button("Don't have an account? Register") {
                        showRegister = true
                    }
                    .font(.footnote)
                    .foregroundStyle(Color.gauriprimary)
                    
                    Spacer()
                }
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        
        // Navigate to register view
        .fullScreenCover(isPresented: $showRegister) {
            RegisterView()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    LoginView()
}
