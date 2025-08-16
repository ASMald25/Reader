//
//  PDFViewer.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/14/25.
//

import SwiftUI
import PDFKit

enum VisualSettings {
    static let customColor = NSColor(red: 156/255.0,
                                     green: 101/255.0,
                                     blue: 46/255.0,
                                     alpha: 0.50)
}

struct PDFKitView: NSViewRepresentable {
    let url: URL
    func makeNSView(context: Context) -> PDFView {
       let pdfView = PDFView()
        //Reader window settings
        pdfView.autoScales = true
        pdfView.backgroundColor = VisualSettings.customColor
        
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = PDFDocument(url: url)
    }
}
