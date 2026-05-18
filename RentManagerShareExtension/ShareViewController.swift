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
        
        print("EXTENSION START")
        
        // Start processing incoming shared data
        handleIncomingData()
    }
    
    // Func to process data received from the share sheet
    private func handleIncomingData() {
        
        // Get the first input item from the share extension context
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            complete()
            return
        }
        
        var sharedText: String? = nil
        
        // App group storage to allow communication with the main app
        let groupDefaults = UserDefaults(suiteName: "group.rentmanager")
        
        // Ensure all async tasks complete before proceeding
        let dispatchGroup = DispatchGroup()
        
        // Loop all attachments
        for provider in extensionItem.attachments ?? [] {
            
            print("PROVIDER:", provider.registeredTypeIdentifiers)
            
            // Check if the received item is text
            if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                
                // DispatchGroup to ensure all async tasks complete before proceeding
                dispatchGroup.enter()
                
                // Load text item from the provider
                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { item, error in
                    
                    if let error = error {
                        print("ERROR:", error.localizedDescription)
                    }
                    
                    // Convert loaded item into string
                    if let text = item as? String {
                        sharedText = text
                        print("RECEIVED TEXT:", text)
                    }
                    
                    // Mark this async task as completed
                    dispatchGroup.leave()
                }
            }
        }
        
        // Called when all async task in dispatch group are completed
        dispatchGroup.notify(queue: .main) {
            
            if let text = sharedText {
                // Save text into app group so the main app can access it
                groupDefaults?.set(text, forKey: "sharedText")
                print("SAVED TEXT:", text)
            } else {
                print("NO TEXT FOUND")
            }
            
            // Ensure data is written immediately
            groupDefaults?.synchronize()
            
            // Open the main app
            self.openMainApp()
        }
    }
    
    // Func to open main app
    private func openMainApp() {
        
        // Deep link to specific screen in the main app
        guard let url = URL(string: "rentmanager://new-booking") else {
            complete()
            return
        }
        
        // Delay to ensure app group data is saved properly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            // Search for UIApplication to open main app
            var responder: UIResponder? = self
            while responder != nil {
                if let application = responder as? UIApplication {
                    // Once UIApplication is found, use it to open the main app via deep link
                    application.open(url)
                    print("APP OPENED")
                    break
                }
                responder = responder?.next
            }
            
            // Small delay before closing the extension to ensure the app launch process is triggered
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.complete()
            }
        }
    }
    
    private func complete() {
        print("COMPLETE EXTENSION")
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
