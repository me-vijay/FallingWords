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
    private func testWords(file: String) throws -> [Word] {
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
        let ourTestWords = try! self.testWords(file: filePath!)
        
        //set wordstore using same file
        let wordstore = try! WordStore(jsonFileAt: filePath!)
        
        //test word count
        XCTAssertEqual(wordstore.words.count, ourTestWords.count, "WordStore word count is invalid")
        
        //generate a random index, to test word similarity
        let randomIndex = Int.random(in: 0..<ourTestWords.count)
        
        //words at same index should be same
        XCTAssertEqual(wordstore.words[randomIndex], ourTestWords[randomIndex], "WordStore words are not correct ")
    }
}
