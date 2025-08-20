//
//  JSON.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/20/25.
//

import Foundation

//manages bookmarks based on the name of the file
struct Bookmark: Codable{
    let fileName: String
    let bookmarkPgNum: Int
    
}


//dictionary to both check if pdf has been bookmarked before or to create new bookmarks in a pdf
//inout to avoid modifying copies of dict, pass reference to it
func addOrUpdateBookmark(_ dict: inout [String: Bookmark], filename: URL, bookmarkPgNum: Int) -> String{
    var pdfName: String = filename.lastPathComponent
    dict[pdfName] = Bookmark(fileName: pdfName, bookmarkPgNum:  bookmarkPgNum)
    
    return pdfName
    
}

//receive dict of Bookmark structs, encode every struct in dict
func encodeBookmark(_ dict: inout[String: Bookmark], fileName: String = "bookmarks.json" ) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let data = try encoder.encode(dict)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try data.write(to: fileURL)
        print("Book marks saved to",fileURL.path)
        
    }catch{
        print("Failed to encode Bookmarks:", error)
    }
}

func decodeBookmark(from fileName: String = "bookmarks.json") -> [String: Bookmark] {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
    do {
        let data = try Data(contentsOf: fileURL)
        
        let decoder = JSONDecoder()
        let bookmarksDict = try decoder.decode([String: Bookmark].self, from: data)
        
        return bookmarksDict
    } catch {
        print("failed to load or decode json bookmarks", error)
        return [:]
    }
}
