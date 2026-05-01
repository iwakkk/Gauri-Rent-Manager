//
//  NewOrderView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import SwiftUI

struct NewOrderView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var goToNextPage = false
    @State private var bookingFormText = ""
    @State private var viewModel = NewOrderViewModel()
    @Binding var showOrderSheet : Bool
    
    @State var bookingId: UUID? = nil
    
    var body: some View {
        NavigationStack{
            ScrollView{
                
                VStack(alignment: .leading) {
                    
                    Text("Enter or paste order form here.")
                        .font(.headline)
                    
                    TextEditor(text: $bookingFormText)
                        .frame(height: 300)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    
                    Spacer()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .padding()
            .navigationTitle("New Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let parsedDraft = viewModel.parseOrderText(bookingFormText,  products: viewModel.allProducts)
                        viewModel.parsedDraft = parsedDraft
                        goToNextPage = true
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationDestination(isPresented: $goToNextPage) {
                if let draft = viewModel.parsedDraft {
                    OrderConfirmationView(
                        bookingId: $bookingId,
                        showOrderSheet: $showOrderSheet,
                        draft: draft,)
                }
            }
            .task {
                await viewModel.loadProducts()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    loadSharedText()
                }
            }
        }
        
    }
    
    func loadSharedText() {
        print("TRY LOAD SHARED TEXT")
        
        let defaults = UserDefaults(suiteName: "group.rentmanager")
        
        guard let text = defaults?.string(forKey: "sharedText") else {
            print("NO TEXT FOUND")
            return
        }
        
        print("TEXT FOUND:", text)
        
        DispatchQueue.main.async {
            bookingFormText = text
        }
        
    
        DispatchQueue.global(qos: .userInitiated).async {
            
            let parsed = viewModel.parseOrderText(
                text,
                products: viewModel.allProducts
            )
            
            DispatchQueue.main.async {
                viewModel.parsedDraft = parsed
            }
        }
        
        defaults?.removeObject(forKey: "sharedText")
    }
}


#Preview {
    ContentView()
        .environmentObject(AppState())
}
