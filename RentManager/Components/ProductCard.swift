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
    let recoveryRanges: [(Date, Date)]
    
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
            
            // STATUS
            VStack(alignment: .trailing, spacing: 6) {
                
                // 🔴 RENT RANGES
                if !bookedRanges.isEmpty {
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        ForEach(Array(bookedRanges.enumerated()), id: \.offset) { _, range in
                            
                            Text("\(formatDate(range.0)) - \(formatDate(range.1))")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.15))
                                .foregroundColor(.red)
                                .clipShape(Capsule())
                        }
                    }
                }
                
                // 🟡 RECOVERY RANGES (NEW)
                if !recoveryRanges.isEmpty {
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        ForEach(Array(recoveryRanges.enumerated()), id: \.offset) { _, range in
                            
                            let end = formatDate(range.1)
                            
                            Text("In Maintenance Until: \(end)")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.15))
                                .foregroundColor(.orange)
                                .clipShape(Capsule())
                        }
                    }
                }
                
                // 🟢 AVAILABLE
                if bookedRanges.isEmpty && recoveryRanges.isEmpty {
                    
                    Text("Available")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
