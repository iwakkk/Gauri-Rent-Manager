//
//  InvoiceStorage.swift
//  RentManager
//
//  Created by Edward Suwandi on 29/04/26.
//

import Foundation

struct InvoiceStorage {
    
    // SAVE PDF KE LOCAL
    static func save(fileURL: URL, bookingId: UUID) throws -> URL {
        
        let fileManager = FileManager.default
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent("invoices", isDirectory: true)
        
        if !fileManager.fileExists(atPath: folder.path) {
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        
        let localURL = folder.appendingPathComponent("invoice-\(bookingId).pdf")
        
        if fileManager.fileExists(atPath: localURL.path) {
            try fileManager.removeItem(at: localURL)
        }
        
        try fileManager.copyItem(at: fileURL, to: localURL)
        
        return localURL
    }
    
    // GET PDF FROM LOCAL
    static func get(bookingId: UUID) -> URL? {
        
        let fileManager = FileManager.default
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let localURL = documents
            .appendingPathComponent("invoices")
            .appendingPathComponent("invoice-\(bookingId).pdf")
        
        return fileManager.fileExists(atPath: localURL.path) ? localURL : nil
    }
    
    // CHECK INVOICE COUNT IN LOCAL STORAGE
    static func getInvoiceFileCount() -> Int {
        
        let fileManager = FileManager.default
        
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent("invoices")
        
        guard let files = try? fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) else {
            return 0
        }
        
        return files.count
    }

    // CHECK INVOICE MEMORY SIZE IN LOCAL
    static func getInvoiceTotalSize() -> Double {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documents.appendingPathComponent("invoices")
        
        guard let files = try? fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        
        var totalSize: Double = 0
        
        for file in files {
            if let size = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                totalSize += Double(size)
            }
        }
        
        return totalSize / (1024 * 1024) // MB
    }
    
}
