//
//  WordStore.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

/// Store of words
class WordStore {
    
    /// words in the store
    private (set) var words: [Word]
    
    /// convenience initializer to create word store from a json file having array of words
    ///
    /// - Parameter file: path of the json file
    /// - Throws: throws any error occurred while reading from file
    convenience init(jsonFileAt file: String) throws {
        //read file in String
        let jsonString = try String.init(contentsOfFile: file)
        
        //convert String to Data
        let jsonData = jsonString.data(using: .utf8)
        
        //initialize with JSON Data
        try self.init(jsonData: jsonData!)
    }
    
    
    /// initializer with json Data
    ///
    /// - Parameter jsonData: json in Data form
    /// - Throws: throws any error occurred while creating model objects from Data
    init(jsonData: Data) throws {
        //create json decoder
        let decoder = JSONDecoder()
        
        //create Word array from json data
        words = try decoder.decode([Word].self, from: jsonData)
    }
}
