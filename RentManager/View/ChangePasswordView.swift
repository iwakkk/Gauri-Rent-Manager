//
//  ChangePasswordView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var password: String = ""
    @State private var newPassword: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                FormFieldRow(title: "Your Password", text: $password)
                FormFieldRow(title: "New Password", text: $newPassword)
            }
            .padding()
            .navigationTitle("Change Password")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // To do : logic save changed password
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
        
    }
}

#Preview {
    ChangePasswordView()
}
