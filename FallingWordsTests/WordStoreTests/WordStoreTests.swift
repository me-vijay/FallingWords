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

    func test_Init_SetsCorrectWords() {
        //file path of test words
        let bundle = Bundle(for: type(of: self))
        let filePath = bundle.path(forResource: "test_words", ofType: "json")
        
        //read using our own method from test file
        let ourTestWords = try! WordStore.getWords(file: filePath!)
        
        //set wordstore using same file
        let wordStore = try! WordStore(jsonFileAt: filePath!)
        
        //test the word count
        XCTAssertEqual(wordStore.words.count, ourTestWords.count, "WordStore word count is invalid")
        
        //words should be same
        XCTAssertEqual(wordStore.words, ourTestWords, "WordStore words are not correct ")
    }
}
