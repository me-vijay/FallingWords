//
//  WordStore+Extension.swift
//  FallingWordsTests
//
//  Created by Vijay Kumar on 29/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation
@testable import FallingWords

extension WordStore {
     static func getWords(file: String) throws -> [Word] {
        //read file in String
        let jsonString = try String.init(contentsOfFile: file)
        
        //convert String to Data
        let jsonData = jsonString.data(using: .utf8)
        
        //create json decoder
        let decoder = JSONDecoder()
        
        //create Word array from json data
        let words = try decoder.decode([Word].self, from: jsonData!)
        
        return words
    }
}
