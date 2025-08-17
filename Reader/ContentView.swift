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
        ZStack{
            Color(nsColor: VisualSettings.customBackColor).ignoresSafeArea()
            
            VStack{
                HStack{
                    //button to load pdf from file finder
                    Button("Select PDF"){
                        if let file = FileFinder() {
                            selectedPDF = file
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(minWidth: 90, idealWidth: 110, minHeight: 30, idealHeight: 40)
                    .background(Color(VisualSettings.complementaryColor), in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.white)
                    //Horizontally add buttons such as highlight
                    //Toolbar everpresent at top
                    //add bookmark functionality
                    //memory perisistance such as json in appData
                    
                }.padding(.top, 10)
                
                if let url = selectedPDF{
                    PDFKitView(url: url).frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    //unused
                }
                
            }
        }
    }
}
            
    

#Preview {
    ContentView()
}
