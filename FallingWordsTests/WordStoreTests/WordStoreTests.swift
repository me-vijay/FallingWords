//
//  WordStoreTests.swift
//  FallingWordsTests
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import XCTest
@testable import FallingWords

class WordStoreTests: XCTestCase {

    /// method to get test words
    ///
    /// - Returns: array of type Word
    private func getTestWords(file: String) throws -> [Word] {
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
    
    func test_Init_SetsCorrectWords() {
        //file path of test words
        let bundle = Bundle(for: type(of: self))
        let filePath = bundle.path(forResource: "test_words", ofType: "json")
        
        //read using our own method from test file
        let ourTestWords = try! self.getTestWords(file: filePath!)
        
        //set wordstore using same file
        let wordStore = try! WordStore(jsonFileAt: filePath!)
        
        //test the word count
        XCTAssertEqual(wordStore.words.count, ourTestWords.count, "WordStore word count is invalid")
        
        //words should be same
        XCTAssertEqual(wordStore.words, ourTestWords, "WordStore words are not correct ")
    }
}
