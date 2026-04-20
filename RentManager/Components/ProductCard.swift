//
//  ProductCard.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import SwiftUI

struct ProductCard: View {
    
    let product: Products
    
    var body: some View {
        HStack(spacing: 12) {
            
            // MARK: - IMAGE
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
                    // Fallback kalau tidak ada image
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
            
            // MARK: - TEXT INFO
            VStack(alignment: .leading, spacing: 6) {
                
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(product.color) • \(product.size)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Rp \(product.price, specifier: "%.0f")")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
//                    Text("Stock: \(product.stock)")
//                        .font(.caption)
//                        .foregroundColor(product.stock > 0 ? .green : .red)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview("With Image") {
    ProductCard(
        product: Products(
            id: UUID(),
            name: "Elegant Dress",
            color: "Black",
            size: ["M"],
            price: 250000,
            isRented: false,
            imageUrl: "https://via.placeholder.com/150"
        )
    )
    .padding()
    .previewLayout(.sizeThatFits)
}

#Preview("No Image") {
    ProductCard(
        product: Products(
            id: UUID(),
            name: "Casual Shirt",
            color: "White",
            size: ["L"],
            price: 150000,
            isRented: false,
            imageUrl: nil
        )
    )
    .padding()
    .previewLayout(.sizeThatFits)
}
