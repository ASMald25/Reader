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
    @State private var haveBookMarkedBool = false
    @State private var currentPage: Int?
    @State private var pdfName: String = ""
    @State private var lastCommittedPage: Int? = nil   // prevents redundant writes
    @Environment(\.scenePhase) private var scenePhase   // tracks app lifecycle

    // Save the last page for the current PDF (used only on app close / pdf switch)
    private func commitLastPageForCurrentPDF() {
        guard let lastPage = currentPage, !pdfName.isEmpty else { return }
        guard lastCommittedPage != lastPage else { return } // skip redundant writes
        var bookmarksDict = decodeBookmark(from: "bookmarks.json")
        saveLastPage(&bookmarksDict, currentPage: lastPage, pdfName: pdfName)
        encodeBookmark(&bookmarksDict)
        lastCommittedPage = lastPage
    }

    var body: some View {
        ZStack {
            Color(nsColor: VisualSettings.customBackColor).ignoresSafeArea()

            VStack {
                HStack {
                    // Select PDF
                    Button("Select PDF") {
                        if let file = FileFinder() {
                            // Save old PDF before switching
                            if selectedPDF != nil {
                                commitLastPageForCurrentPDF()
                            }

                            // Switch to new PDF
                            selectedPDF = file
                            areViewingPDFBool = true
                            pdfName = file.lastPathComponent

                            // Reset state; don’t auto-load last page
                            currentPage = nil
                            lastCommittedPage = nil
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 90, idealWidth: 110, minHeight: 30, idealHeight: 40)
                    .background(Color(VisualSettings.complementaryColor), in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)

                    if areViewingPDFBool {
                        // Bookmark Page
                        Button("Bookmark Page") {
                            var bookmarksDict = decodeBookmark(from: "bookmarks.json")
                            if let page = currentPage, let selectedPDF {
                                print("Bookmarked page \(page)")
                                haveBookMarkedBool = true
                                _ = addOrUpdateBookmark(&bookmarksDict, filename: selectedPDF, bookmarkPgNum: page)
                                encodeBookmark(&bookmarksDict)
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(minWidth: 90, idealWidth: 110, minHeight: 30, idealHeight: 40)
                        .background(Color(VisualSettings.complementaryColor), in: RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)

                        // Jump to Bookmark
                        Button("Jump to Bookmark") {
                            let bookmarksDict = decodeBookmark(from: "bookmarks.json")
                            let bookmarkNum = bookmarksDict[pdfName]?.bookmarkPgNum ?? 0
                            currentPage = bookmarkNum
                        }
                        .buttonStyle(.plain)
                        .frame(minWidth: 90, idealWidth: 110, minHeight: 30, idealHeight: 40)
                        .background(Color(VisualSettings.complementaryColor), in: RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)

                        // NEW: Jump to Last Page
                        Button("Jump to Last Page") {
                            let bookmarksDict = decodeBookmark(from: "bookmarks.json")
                            if let lastPage = bookmarksDict[pdfName]?.lastPageOpened {
                                currentPage = lastPage
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(minWidth: 90, idealWidth: 110, minHeight: 30, idealHeight: 40)
                        .background(Color(VisualSettings.complementaryColor), in: RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                    }
                }
                .padding(.top, 10)

                if let url = selectedPDF {
                    PDFKitView(url: url, currentPage: $currentPage)
                        .id(url) // ensures refresh on PDF change
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        // Save last page when app goes background/inactive
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                commitLastPageForCurrentPDF()
            }
        }
    }
}

#Preview {
    ContentView()
}


