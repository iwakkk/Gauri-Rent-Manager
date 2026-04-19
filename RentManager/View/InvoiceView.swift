//
//  InvoiceView.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

import SwiftUI

struct InvoiceView: View {
    
    var bookingId: UUID
    @Binding var showOrderSheet: Bool
    
    @State private var booking: Bookings?
    @State private var isLoading = true
    
    private let service = BookingsService()
    
    var body: some View {
        
        VStack {
            
            if isLoading {
                ProgressView("Loading Invoice...")
            }
            else if let urlString = booking?.invoiceURL,
                    let url = URL(string: urlString) {
                
                PDFKitView(url: url)
                
            } else {
                Text("No Invoice Found")
                    .foregroundColor(.secondary)
            }
            
            Button("Done") {
                showOrderSheet = false
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Invoice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                if let urlString = booking?.invoiceURL,
                   let url = URL(string: urlString) {
                    
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Done") {
                    showOrderSheet = false
                }
            }
        }
        .task {
            await loadBooking()
        }
    }
    
    // MARK: - Load single booking
    func loadBooking() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let bookings = try await service.fetchBookings()
            
            self.booking = bookings.first(where: {
                $0.id == bookingId
            })
            
        } catch {
            print("❌ error loading booking:", error)
        }
    }
}
