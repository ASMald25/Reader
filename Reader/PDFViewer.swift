//
//  PDFViewer.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/14/25.
//

import SwiftUI
import PDFKit
import AppKit

// Turn hex into a NSColor object
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
    static let customBackColor = NSColor(hex: "#6f301e") ?? NSColor.black
    static let complementaryColor = NSColor(hex: "#1E5D6F") ?? NSColor.white
}

struct PDFKitView: NSViewRepresentable {
    let url: URL
    @Binding var currentPage: Int?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.backgroundColor = VisualSettings.customBackColor
        context.coordinator.pdfView = pdfView

        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.pageChanged(_:)),
            name: .PDFViewPageChanged,
            object: pdfView
        )

        return pdfView
    }

    func updateNSView(_ nsView: PDFView, context: Context) {
        // Ensure document is loaded
        if nsView.document == nil {
            nsView.document = PDFDocument(url: url)
        }

        // Only jump if the current page is different from the PDFView's page
        if let targetPage = currentPage,
           let document = nsView.document,
           targetPage > 0,
           targetPage <= document.pageCount,
           let page = document.page(at: targetPage - 1),
           nsView.currentPage != page {
            nsView.go(to: page)
        }
    }

    func jumpToPage(_ pageNumber: Int, context: Context) {
        context.coordinator.goToPage(pageNumber)
    }

    class Coordinator: NSObject {
        var parent: PDFKitView
        weak var pdfView: PDFView?

        private var lastReportedPage: Int? = nil

        init(_ parent: PDFKitView) {
            self.parent = parent
        }

        @objc func pageChanged(_ notification: Notification) {
            guard let pdfView = notification.object as? PDFView,
                  let page = pdfView.currentPage,
                  let index = pdfView.document?.index(for: page) else { return }

            let pageNumber = index + 1
            // Only update binding if page actually changed
            if lastReportedPage != pageNumber {
                lastReportedPage = pageNumber
                parent.currentPage = pageNumber
            }
        }

        func goToPage(_ pageNumber: Int) {
            guard let pdfView = pdfView,
                  let document = pdfView.document,
                  pageNumber > 0,
                  pageNumber <= document.pageCount,
                  let page = document.page(at: pageNumber - 1) else {
                print("Invalid page number", pageNumber)
                return
            }

            pdfView.go(to: page)
            lastReportedPage = pageNumber
            parent.currentPage = pageNumber
        }
    }
}
