//
//  JSON.swift
//  Reader
//
//  Created by Alexander Maldonado on 8/20/25.
//

import Foundation

// Manages bookmarks based on the name of the file
struct Bookmark: Codable {
    let fileName: String
    let bookmarkPgNum: Int
}

// Dictionary to check if PDF has been bookmarked before or to create new bookmarks
// inout to avoid modifying copies of dict, pass reference to it
func addOrUpdateBookmark(_ dict: inout [String: Bookmark], filename: URL, bookmarkPgNum: Int) -> String {
    let pdfName: String = filename.lastPathComponent
    dict[pdfName] = Bookmark(fileName: pdfName, bookmarkPgNum: bookmarkPgNum)
    return pdfName
}

// Create the JSON file if it doesn't exist
func createJSON(fileName: String = "bookmarks.json") {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
    // Check if file exists
    if !FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            // Create an empty dictionary and write as JSON
            let emptyDict: [String: Bookmark] = [:]
            let data = try JSONEncoder().encode(emptyDict)
            try data.write(to: fileURL)
            print("Created empty bookmarks.json at:", fileURL.path)
        } catch {
            print("Failed to create bookmarks.json:", error)
        }
    }
}

// Encode bookmarks dictionary to JSON
func encodeBookmark(_ dict: inout [String: Bookmark], fileName: String = "bookmarks.json") {
    //check to see if json exists, if not create
    createJSON(fileName: fileName)
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let data = try encoder.encode(dict)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        try data.write(to: fileURL)
        print("Bookmarks saved to:", fileURL.path)
    } catch {
        print("Failed to encode bookmarks:", error)
    }
}

// Decode bookmarks dictionary from JSON
func decodeBookmark(from fileName: String = "bookmarks.json") -> [String: Bookmark] {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsDirectory.appendingPathComponent(fileName)
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let bookmarksDict = try decoder.decode([String: Bookmark].self, from: data)
        return bookmarksDict
    } catch {
        print("Failed to load or decode bookmarks, creating file:", error)
        createJSON(fileName: fileName)
        return [:]
    }
}
