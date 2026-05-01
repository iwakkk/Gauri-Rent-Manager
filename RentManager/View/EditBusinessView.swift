//
//  EditProfileView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//
import SwiftUI

struct EditBusinessView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var name: String = ""
    @State var phone: String = ""
    @State var address: String = ""
    @State var email: String = ""
    
    @State var bankName: String = ""
    @State var bankNumber: String = ""
    @State var bankAccountName: String = ""
    
    var viewModel: BusinessProfileViewModel
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(spacing: 16) {
                        FormFieldRow(title: "Business Name", text: $name)
                        FormFieldRow(title: "Phone", text: $phone, keyboard: .phonePad)
                        FormFieldRow(title: "Address", text: $address)
                        FormFieldRow(title: "Email", text: $email, keyboard: .emailAddress)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        FormFieldRow(title: "Bank Name", text: $bankName)
                        FormFieldRow(title: "Account Number", text: $bankNumber, keyboard: .numberPad)
                        FormFieldRow(title: "Account Name", text: $bankAccountName)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color.gauribackground.ignoresSafeArea())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Edit Business")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // Dismiss
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.primary)
                    }
                }
                
                // Save
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            let draft = BusinessProfileDraft(
                                name: name,
                                phone: phone,
                                address: address,
                                email: email,
                                bankName: bankName,
                                bankNumber: bankNumber,
                                bankAccountName: bankAccountName
                            )
                           
                            await viewModel.updateBusiness(with: draft)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    // Load data
    func loadData() {
        let b = viewModel.business
        
        name = b?.businessName ?? ""
        phone = b?.businessPhone ?? ""
        address = b?.businessAddress ?? ""
        email = b?.email ?? ""
        
        bankName = b?.bankName ?? ""
        bankNumber = b?.bankNumber ?? ""
        bankAccountName = b?.bankAccountName ?? ""
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
