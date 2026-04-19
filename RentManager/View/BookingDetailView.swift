//
//  BookingDetailView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/02/26.
//

import SwiftUI

struct BookingDetailView: View {
    
    @State var draft: BookingDraft
    var allProducts: [Products]
    
    // Use the booking id that made before
    @Binding var bookingId: UUID?
    
    @State private var showConfirmation = false
    @State private var goToInvoicePage = false
    @State private var showValidationAlert: Bool = false
    @State private var viewModel = BookingDetailViewModel()
    
    @State private var pdfURL: URL?
    
    @Binding var showOrderSheet : Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                // Customer Details
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Customer Details")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    // Select Customer from database
                    Text("Select Customer")
                        .font(.headline)

                    Picker("Select Customer", selection: Binding(
                        get: {
                            viewModel.customers.first(where: {
                                $0.name == draft.customerName &&
                                $0.phone == draft.customerPhone &&
                                $0.bankAccount == draft.customerBankAccount
                            })
                        },
                        set: { newValue in
                            if let c = newValue {
                                draft.customerName = c.name
                                draft.customerPhone = c.phone
                                draft.customerBankAccount = c.bankAccount
                            } else {
                                draft.customerName = ""
                                draft.customerPhone = ""
                                draft.customerBankAccount = ""
                            }
                        }
                    )) {
                        Text("Select Customer").tag(Customers?.none)

                        ForEach(viewModel.customers, id: \.id) { customer in
                            Text(customer.name)
                                .tag(Optional(customer))
                        }
                    }
                    .pickerStyle(.menu)
                    
                    VStack(spacing: 14) {
                        FormFieldRow(title: "Customer Name", text: $draft.customerName)
                        FormFieldRow(title: "Address", text: $draft.customerAddress)
                        FormFieldRow(title: "Phone Number", text: $draft.customerPhone, keyboard: .numberPad)
                        FormFieldRow(title: "Bank Account", text: $draft.customerBankAccount, keyboard: .numberPad)
                    }
                }
                
                
                // Order Details
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Order Details")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(draft.items.indices, id: \.self) { index in
                        
                        VStack(spacing: 14) {
                            
                            HStack {
                                
                                Text("Product")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                if draft.items.count > 1 {
                                    Button {
                                        draft.items.remove(at: index)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            
                            Picker("Select Product", selection: Binding(
                                get: { draft.items[index].selectedProduct },
                                set: { newValue in
                                    draft.items[index].selectedProduct = newValue
                                    
                                    if let product = newValue {
                                        draft.items[index].productName = product.name
                                        draft.items[index].color = product.color
                                        draft.items[index].size = product.size
                                        draft.items[index].price = product.price
                                    }
                                }
                            )) {
                                Text("Select From Catalog").tag(Products?.none)

                                ForEach(allProducts, id: \.id) { product in
                                    Text("\(product.name) - \(product.color) - \(product.size)")
                                        .tag(Optional(product))
                                }
                            }
                            .pickerStyle(.menu)
                            
                            FormFieldRow(
                                title: "Nama Produk",
                                text: $draft.items[index].productName
                            )
                            
                            FormFieldRow(
                                title: "Quantity",
                                text: Binding(
                                    get: { String(draft.items[index].quantity) },
                                    set: { draft.items[index].quantity = Int($0) ?? 1 }
                                ),
                                keyboard: .numberPad
                            )
                            
                            FormFieldRow(
                                title: "Color",
                                text: $draft.items[index].color
                            )

                            FormFieldRow(
                                title: "Size",
                                text: $draft.items[index].size
                            )

                            FormFieldRow(
                                title: "Price",
                                text: Binding(
                                    get: { String(Int(draft.items[index].price)) },
                                    set: { draft.items[index].price = Double($0) ?? 0 }
                                ),
                                keyboard: .numberPad
                            )
                            
                            HStack {
                                Spacer()
                                Text("Subtotal: Rp \(Int(draft.items[index].subtotal))")
                                    .fontWeight(.semibold)
                            }
                            
                            Divider()
                        }
                    }
                    
                    Button {
                        draft.items.append(BookingItemDraft())
                    } label: {
                        Label("Add Product", systemImage: "plus.circle.fill")
                    }
                }
                
                // Rent Period
                VStack(alignment: .leading, spacing: 16) {

                    Text("Rent Period")
                        .font(.title3)
                        .fontWeight(.bold)

                    VStack(spacing: 14) {

                        DatePicker(
                            "Start Date",
                            selection: $draft.rentStartDate,
                            displayedComponents: .date
                        )

                        DatePicker(
                            "End Date",
                            selection: $draft.rentEndDate,
                            displayedComponents: .date
                        )
                    }
                }
                
                // Cost Details
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Cost Details")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 14) {
                        
                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text("Rp \(Int(draft.subtotalAmount))")
                        }
                        
                        FormFieldRow(
                            title: "Deposit",
                            text: Binding(
                                get: { String(draft.deposit) },
                                set: { draft.deposit = Double($0) ?? 0 }
                            ),
                            keyboard: .numberPad
                        )
                        
                        FormFieldRow(
                            title: "Shipping Fee",
                            text: Binding(
                                get: { String(draft.shippingFee) },
                                set: { draft.shippingFee = Double($0) ?? 0 }
                            ),
                            keyboard: .numberPad
                        )
                        
                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            Text("Rp \(Int(draft.totalAmount))")
                                .fontWeight(.bold)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Rent Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    if viewModel.isFormValid(draft) {
                           showConfirmation = true
                       } else {
                           showValidationAlert = true
                       }
                }label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Confirmation", isPresented: $showConfirmation) {
            
            Button("Cancel", role: .cancel) { }
            
            Button("Next to Invoice") {
                
                Task {
                    do {
                        
                        // generate invoice PDF
                        let invoiceView = InvoiceContentView(
                            draft: draft,
                            bookingId: $bookingId
                        )
                        let pdfURL = PDFGenerator.generate(from: invoiceView)
                        
                        // create/update booking to database
                        if bookingId == nil {
                            bookingId = try await viewModel.createBooking(draft)
                        } else {
                            try await viewModel.updateBooking(bookingId!, draft)
                        }
                        
                        goToInvoicePage = true
                        
                    } catch {
                        print(error)
                    }
                }
            }
            
        } message: {
            Text("The booking details will be saved to the database and continue to the Invoice.")
        }
        .alert("Incomplete Form", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please fill in all fields before continuing.")
        }
        .navigationDestination(isPresented: $goToInvoicePage) {
            InvoiceView(
                draft: draft,
                showOrderSheet: $showOrderSheet,
                bookingId: $bookingId
            )
        }
        .task {
            await viewModel.loadCustomers()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
