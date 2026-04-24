//
//  EditProfileView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

//import SwiftUI

//struct EditBusinessView: View {
//    let business: BusinessProfile
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var businessName: String = ""
//    @State private var businessPhone: String = ""
//    @State private var businessAddress: String = ""
//    @State private var showPasswordSheet: Bool = false
//    
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 24) {
//                    
//                    // MARK: Account Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Account")
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                        
//                        FormFieldRow(title: "Email", text: $email)
//                        
//                        Button{
//                            showPasswordSheet = true
//                        } label: {
//                            Text("Change Password")
//                        }
//                    }
//                    
//                    // MARK: Business Section
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("Business Info")
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                        
//                        FormFieldRow(title: "Business Name", text: $businessName)
//                        
//                        FormFieldRow(
//                            title: "Business Phone",
//                            text: $businessPhone,
//                            keyboard: .numberPad
//                        )
//                        
//                        FormFieldRow(title: "Business Address", text: $businessAddress)
//                    }
//                    
//                    
//                    Spacer()
//                }
//                .padding()
//            }
//            .sheet(isPresented: $showPasswordSheet){
//                ChangePasswordView()
//                    .presentationDetents([.medium])
//            }
//            .onAppear {
//                email = business.email
//                businessName = business.businessName
//                businessPhone = String(business.businessPhone)
//                businessAddress = business.businessAddress
//            }
//            .toolbar {
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        // TO DO: save logic
//                        print("Save tapped")
//                    } label: {
//                        Text("Save")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//            }
//            .navigationTitle("Edit Profile")
//        }
//    }
//}
//
//
//#Preview {
//    EditBusinessView(
//        business: BusinessProfile(
//            id: UUID(),
//            email: "test@mail.com",
//            businessName: "My Business",
//            businessPhone: 812345678,
//            businessAddress: "Surabaya",
//            bankName: "",
//            bankNumber: 0
//        )
//    )
//}
//
//#Preview {
//    ContentView()
//}
