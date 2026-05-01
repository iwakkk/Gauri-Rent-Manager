//
//  ProductCard.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import SwiftUI

struct ProductCard: View {
    
    let product: Products
    let bookedRanges: [(Date, Date)]
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            
            // IMAGE
            ZStack {
                if let urlString = product.imageUrl,
                   let url = URL(string: urlString) {
                    
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            .frame(width: 70, height: 70)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // INFO
            VStack(alignment: .leading, spacing: 4) {
                
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(product.color)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Rp \(product.price, specifier: "%.0f")")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // MARK: - STATUS (RIGHT SIDE)
            VStack(alignment: .trailing, spacing: 4) {
                
                if bookedRanges.isEmpty {
                    
                    Text("Available")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                    
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            
                            ForEach(Array(bookedRanges.enumerated()), id: \.offset) { _, range in
                                
                                let start = formatDate(range.0)
                                let end = formatDate(range.1)
                                
                                Text("\(start) - \(end)")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.15))
                                    .foregroundColor(.red)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .frame(maxHeight: 80) // penting supaya card tidak ikut memanjang
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
