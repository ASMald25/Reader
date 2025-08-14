//
//  ContentView.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/12/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var selectedPDF: URL?
    
    var body: some View {
        VStack{
            HStack{
                //button to load pdf from file finder
                Button("Select PDF") {
                    if let file = FileFinder() {
                        selectedPDF = file
                    }
                //Horizontally add buttons such as highlight
                //Toolbar everpresent at top
                //add bookmark functionality
                //memory perisistance such as json in appData
                    
                }
            }
            if let url = selectedPDF{
                PDFKitView(url: url).frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No PDF Loaded")
                }
            }
        }
            
        }
    

#Preview {
    ContentView()
}
