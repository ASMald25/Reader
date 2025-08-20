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
func addOrUpdateBookmark(_ dict: inout [String: Bookmark], filename: URL, bookmarkPgNum: Int){
    var pdfName: String = filename.lastPathComponent
    dict[pdfName] = Bookmark(fileName: pdfName, bookmarkPgNum:  bookmarkPgNum)
    
}
