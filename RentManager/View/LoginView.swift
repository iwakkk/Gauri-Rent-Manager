//
//  LoginView.swift
//  RentManager
//
//  Created by Edward Suwandi on 09/02/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appState: AppState
    
    @State var email: String = ""
    @State var password: String = ""
    @State var showError = false
    
    var viewModel = LoginViewModel()
    
    var body: some View {
        
        VStack{
            Text("RENT MANAGER")
                .font(.title3.bold())
            
            Text("Login To Continue")
                .font(.title3.bold())
                .padding()
            
            VStack(spacing: 20){
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                TextField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            // Login Button
            Button(action: {
                
                Task {
                let user = await viewModel.login(email: email, password: password)
                
                if let user = user {
                    appState.currentUser = user
                } else {
                    showError = true
                }
            }
            }){
                Text("Login")
            }
            .alert("Login gagal", isPresented: $showError) {
                            Button("OK", role: .cancel) {}
            } message: {
                Text("Email atau password salah")
            }
            
        }
    }
}

//
//#Preview {
//    LoginView()
//}
