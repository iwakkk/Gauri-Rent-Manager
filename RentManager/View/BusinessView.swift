//
//  BusinessView.swift
//  RentManager
//
//  Created by Edward Suwandi on 13/04/26.
//

import SwiftUI

struct BusinessView: View {
    
    @State private var viewModel = BusinessProfileViewModel()
    @State private var showEditSheet = false
    
    var body: some View {
        
        VStack {
            
            Title(
                title: "Business",
                actionIcon: "square.and.pencil",
                actionTap: {
                    showEditSheet = true
                }
            )
            
            VStack {
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    List {
                        VStack{
                            if let urlString = viewModel.business?.businessImageURL,
                               let url = URL(string: urlString) {
                                
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .background(
                                            Circle()
                                                .fill(Color(.black))
                                        )
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 140, height: 140)
                                
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(20)
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                            Text(viewModel.business?.businessName ?? "")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                        
                        Section("Business Details") {
                            InfoRow(icon: "phone" ,title: "Phone", value: viewModel.business?.businessPhone)
                            InfoRow(icon: "location" ,title: "Address", value: viewModel.business?.businessAddress)
                            InfoRow(icon: "envelope" ,title: "Email", value: viewModel.business?.email)
                        }
                        
                        Section("Bank") {
                            InfoRow(icon: "building.columns", title: "Bank", value: viewModel.business?.bankName)
                            InfoRow(icon: "creditcard",title: "Account", value: viewModel.business?.bankNumber)
                            InfoRow(icon: "person.text.rectangle",title: "Account", value: viewModel.business?.bankAccountName)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .background(Color.gauribackground.ignoresSafeArea())
        }
       
        .task {
            await viewModel.loadBusinessProfile()
        }
        .sheet(isPresented: $showEditSheet) {
            
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String?
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value ?? "-")
                
                .foregroundStyle(.secondary)
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}


