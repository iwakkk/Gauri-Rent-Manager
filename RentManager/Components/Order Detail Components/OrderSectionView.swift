//
//  OrderSectionView.swift
//  RentManager
//
//  Created by Edward Suwandi on 19/04/26.
//

import SwiftUI

struct OrderSectionView: View {
    
    @Binding var draft: BookingDraft
    var viewModel: ProductsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Product Details")
                .font(.title3)
                .fontWeight(.bold)
            
            ForEach(draft.items.indices, id: \.self) { index in
                OrderItemView(
                    item: $draft.items[index],
                    viewModel: viewModel,
                    onDelete: {
                        draft.items.remove(at: index)
                    },
                    canDelete: draft.items.count > 1,
                    count: index + 1
                )
            }
            
            Button {
                draft.items.append(BookingItemDraft())
            } label: {
                Label("Add Item", systemImage: "plus.circle.fill")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
