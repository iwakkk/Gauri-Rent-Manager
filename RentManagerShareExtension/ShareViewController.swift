//
//  ShareViewController.swift
//  RentManagerShareExtension
//
//  Created by Edward Suwandi on 05/04/26.
//


import UIKit
import UniformTypeIdentifiers


class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🚀 EXTENSION START")
        handleIncomingData()
    }
    
    private func handleIncomingData() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            complete()
            return
        }
        
        var sharedText: String? = nil
        let groupDefaults = UserDefaults(suiteName: "group.rentmanager")
        
        let dispatchGroup = DispatchGroup()
        
        for provider in extensionItem.attachments ?? [] {
            
            print("🔍 PROVIDER:", provider.registeredTypeIdentifiers)
            
            // 🔥 HANDLE TEXT
            if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                
                dispatchGroup.enter()
                
                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { item, error in
                    
                    if let error = error {
                        print("❌ ERROR:", error.localizedDescription)
                    }
                    
                    if let text = item as? String {
                        sharedText = text
                        print("📝 RECEIVED TEXT:", text)
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            if let text = sharedText {
                groupDefaults?.set(text, forKey: "sharedText")
                print("💾 SAVED TEXT:", text)
            } else {
                print("⚠️ NO TEXT FOUND")
            }
            
            groupDefaults?.synchronize()
            
            self.openMainApp()
        }
    }
    
    private func openMainApp() {
        guard let url = URL(string: "rentmanager://new-booking") else {
            complete()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            var responder: UIResponder? = self
            while responder != nil {
                if let application = responder as? UIApplication {
                    application.open(url)
                    print("🚀 APP OPENED")
                    break
                }
                responder = responder?.next
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.complete()
            }
        }
    }
    
    private func complete() {
        print("✅ COMPLETE EXTENSION")
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
