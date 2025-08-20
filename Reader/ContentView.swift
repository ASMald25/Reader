//
//  ContentView.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/12/25.
//

import SwiftUI
import AppKit
import PDFKit

struct ContentView: View {
    @State private var selectedPDF: URL?
    @State private var areViewingPDFBool = false
    @State private var currentPage: Int?
    @State private var bookmarksDict: [String: Bookmark] = [:]
    @State private var pdfName: String = ""

    var body: some View {
        ZStack {
            Color(nsColor: VisualSettings.customBackColor).ignoresSafeArea()
            var bookmarksDict = decodeBookmark(from: "bookmarks.json")

            VStack {
                HStack {
                    // button to load pdf from file finder
                    Button("Select PDF") {
                        if let file = FileFinder() {
                            selectedPDF = file
                            areViewingPDFBool = true
                            currentPage = nil //change this code to load last page later on
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 90, idealWidth: 110, minHeight: 30, idealHeight: 40)
                    .background(Color(VisualSettings.complementaryColor), in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)

                    if areViewingPDFBool {
                        Button("Bookmark Page") {
                            if let page = currentPage {
                                print("Bookmarked page \(page)")
                                _ = addOrUpdateBookmark(&bookmarksDict, filename: selectedPDF!, bookmarkPgNum: page)
                                
                                
                            }
                        }
                        Button("Print Dict"){
                            for (key, value) in bookmarksDict{ print(key,":", value)}
                        }
                        
                    }
                }
                .padding(.top, 10)

                if let url = selectedPDF {
                    PDFKitView(url: url, currentPage: $currentPage)
                        .id(url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                   //     .onAppear{ print(url.lastPathComponent) } use to find file path
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
