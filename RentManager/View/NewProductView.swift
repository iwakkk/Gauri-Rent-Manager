//
//  NewProductView.swift
//  RentManager
//
//  Created by Edward Suwandi on 20/04/26.
//

import SwiftUI
import PhotosUI

struct NewProductView: View {
    
    @Environment(\.dismiss) var dismiss
    var viewModel: ProductsViewModel
    
    
    @State var draft : ProductDraft = ProductDraft(
        id: UUID(),
            name: "",
            color: "",
            size: [],
            price: 0,
            isRented: false,
            imageUrl: nil

    )
    
    // MARK: IMAGE (OPTIONAL)
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data? = nil
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {

                    
                    // MARK: FORM FIELDS (CONSISTENT STYLE)
                    VStack(spacing: 14) {
                        
                        FormFieldRow(title: "Product Name", text: $draft.name)
                        FormFieldRow(title: "Color", text: $draft.color)
                        FormFieldRow(
                            title: "Price",
                            text: Binding(
                                get: {
                                    String(draft.price)
                                },
                                set: { newValue in
                                    draft.price = Double(newValue) ?? 0
                                }
                            ),
                            keyboard: .decimalPad
                        )
                    }
                    
                    // IMAGE
                    Text("Product Image")
                        .font(.subheadline)


                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images
                    ) {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4),
                                        style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .frame(width: 140, height: 140)

                            if let imageData,
                               let uiImage = UIImage(data: imageData) {
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(.gray)
                                    
                                    Text("Add Photo")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            
                            if imageData != nil {
                                Button {
                                    imageData = nil
                                    selectedImage = nil
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.red)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                .padding(6)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    
                    
                }
                .padding()
            }
            .navigationTitle("New Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.createProduct(
                                from: draft,
                                imageData: imageData
                            )
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.isValid(draft: draft))
                }
            }
            .onChange(of: selectedImage) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }
        }
    }
    
}
#Preview {
    ContentView()
        .environmentObject(AppState())
}
