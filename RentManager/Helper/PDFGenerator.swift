//
//  PDFGenerator.swift
//  RentManager
//
//  Created by Edward Suwandi on 07/03/26.
//

import SwiftUI

    struct PDFGenerator {

        static func generate<V: View>(from view: V) -> URL? {

            let controller = UIHostingController(rootView: view)
            let view = controller.view

            let targetSize = CGSize(width: 595, height: 842)
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .white

            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("invoice.pdf")

            let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: targetSize))

            do {
                try renderer.writePDF(to: url) { context in
                    context.beginPage()
                    view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
                }
                return url
            } catch {
                print("Failed to generate PDF:", error)
                return nil
            }
        }
    }
