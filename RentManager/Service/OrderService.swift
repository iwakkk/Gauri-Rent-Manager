//
//  OrderService.swift
//  RentManager
//
//  Created by Edward Suwandi on 28/02/26.
//

import Foundation
import Supabase

struct OrderUpdate: Encodable {
    let rent_start_date: Date
    let rent_end_date: Date
    let subtotal_amount: Double
    let shipping_fee: Double
    let deposit_amount: Double
    let total_amount: Double
    let invoice_url: String
    let customer_id: UUID
    let address: String
}

struct OrderService {

    // CREATE ORDER
    func createOrder(_ draft: OrderDraft) async throws -> UUID {
        
        let orderId = UUID()
        let customerId = try await findCustomer(draft: draft)

        let order = Orders(
            id: orderId,
            rentStartDate: draft.rentStartDate,
            rentEndDate: draft.rentEndDate,
            subtotalAmount: draft.subtotalAmount,
            shippingFee: draft.shippingFee,
            depositAmount: draft.deposit,
            totalAmount: draft.totalAmount,
            status: .unpaid,
            invoiceURL: nil,
            customerId: customerId,
            address: draft.customerAddress
        )

        try await supabase
            .from("orders")
            .insert(order)
            .execute()

        let items = draft.items.map {
            OrderItems(
                id: UUID(),
                orderId: orderId,
                productId: $0.selectedProduct?.id ?? UUID(),
                quantity: $0.quantity,
                subtotal: $0.subtotal,
                size: $0.size
            )
        }

        try await supabase
            .from("order_items")
            .insert(items)
            .execute()

        
        return orderId
    }

    // UPDATE ORDER WITH THE SAME ORDER ID
    func updateOrder(id: UUID, draft: OrderDraft) async throws {

        // FIND / UPDATE CUSTOMER
        let customerId = try await findCustomer(draft: draft)

        // UPDATE ORDER HEADER
        let data = OrderUpdate(
            rent_start_date: draft.rentStartDate,
            rent_end_date: draft.rentEndDate,
            subtotal_amount: draft.subtotalAmount,
            shipping_fee: draft.shippingFee,
            deposit_amount: draft.deposit,
            total_amount: draft.totalAmount,
            invoice_url: "",
            customer_id: customerId,
            address: draft.customerAddress
        )

        try await supabase
            .from("orders")
            .update(data)
            .eq("id", value: id)
            .execute()

        // REPLACE ITEMS
        try await supabase
            .from("order_items")
            .delete()
            .eq("order_id", value: id)
            .execute()

        let items = draft.items.map {
            OrderItems(
                id: UUID(),
                orderId: id,
                productId: $0.selectedProduct?.id ?? UUID(),
                quantity: $0.quantity,
                subtotal: $0.subtotal,
                size: $0.size
            )
        }

        try await supabase
            .from("order_items")
            .insert(items)
            .execute()
    }

    // CREATE INVOICE AND UPLOAD TO SUPABASE
    func uploadInvoice(fileURL: URL, orderId: UUID) async throws -> String {

        let fileName = "invoice-\(orderId).pdf"
        let data = try Data(contentsOf: fileURL)

        // create file
        try await supabase.storage
            .from("invoices")
            .upload(
                path: fileName,
                file: data,
                options: FileOptions(contentType: "application/pdf", upsert: true)
            )

        let url = try supabase.storage
            .from("invoices")
            .getPublicURL(path: fileName)

        let urlString = url.absoluteString

        // update database with created file
        try await supabase
            .from("orders")
            .update([
                "invoice_url": urlString
            ])
            .eq("id", value: orderId)
            .execute()

        return urlString
    }
    
    // FETCH ALL ORDERS
    func fetchOrders() async throws -> [Orders] {

        return try await supabase
            .from("orders")
            .select("*, customers(*)")
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    // FETCH SINGLE ORDER
    func fetchOrder(by id: UUID) async throws -> Orders {
        
        let response: Orders = try await supabase
            .from("orders")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        return response
    }
        
        

    // FETCH ITEMS
    func fetchItems(for orderId: UUID) async throws -> [OrderItems] {
        
        return try await supabase
            .from("order_items")
            .select("""
                *,
                products (
                    id,
                    name,
                    color,
                    size,
                    price,
                    image_url
                )
            """)
            .eq("order_id", value: orderId)
            .execute()
            .value
    }

    // UPDATE STATUS
    func updateStatus(orderId: UUID, status: OrderStatus) async throws {

        try await supabase
            .from("orders")
            .update([
                "status": status.rawValue
            ])
            .eq("id", value: orderId)
            .execute()
    }
    
    // FETCH BOOKED PRODUCT PERIOD
    func fetchProductBookings(productId: UUID) async throws -> [ProductBooking] {
        
        let result: [ProductBooking] = try await supabase
            .from("product_bookings")
            .select()
            .eq("product_id", value: productId)
            .execute()
            .value
        
        return result
    }
    
    // FIND CUSTOMER
    func findCustomer(draft: OrderDraft) async throws -> UUID {

        let existing: [Customers] = try await supabase
            .from("customers")
            .select()
            .eq("phone", value: draft.customerPhone)
            .execute()
            .value

        if let customer = existing.first {
            return customer.id
        }

        let id = UUID()

        let newCustomer = Customers(
            id: id,
            name: draft.customerName,
            phone: draft.customerPhone,
            bankAccount: draft.customerBankAccount
        )

        try await supabase
            .from("customers")
            .insert(newCustomer)
            .execute()

        return id
    }

    
}
