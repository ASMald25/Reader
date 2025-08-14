//
//  FileFinder.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/14/25.
//

import SwiftUI
import PDFKit

func FileFinder() -> URL? {
    
    let panel = NSOpenPanel()
    panel.title = "Select PDF Files"
    panel.allowedContentTypes = [.pdf]// Only allow PDFs
    panel.canChooseFiles = true
    panel.canChooseDirectories = false
    panel.allowsMultipleSelection = false

    if panel.runModal() == .OK {
        return panel.url // Directly return PDFs
    }
    return nil
}
