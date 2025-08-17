//
//  PDFViewer.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/14/25.
//

import SwiftUI
import PDFKit
import AppKit


//turn hex into a NSColor object
extension NSColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

enum VisualSettings {
    static let customBackColor = NSColor(hex: "#c85637") ?? NSColor.black
    static let complementaryColor = NSColor(hex: "#37A9C8") ?? NSColor.white
}



struct PDFKitView: NSViewRepresentable {
    let url: URL
    func makeNSView(context: Context) -> PDFView {
       let pdfView = PDFView()
        //Reader window settings
        pdfView.autoScales = true
        pdfView.backgroundColor = VisualSettings.customBackColor
        
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = PDFDocument(url: url)
    }
}
