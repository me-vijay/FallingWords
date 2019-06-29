//
//  FallingWordsTests.swift
//  FallingWordsTests
//
//  Created by Vijay Kumar on 28/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import XCTest
@testable import FallingWords

class FallingWordsMechanicsTests: XCTestCase {
    var ourTestWords: [Word]?
    var fallingWordsMechanics: FallingWordsMechanics<EngToSpan>?
    
    override func setUp() {
        //file path of test words
        let bundle = Bundle(for: type(of: self))
        let filePath = bundle.path(forResource: "test_words", ofType: "json")
        
        //read using our own method from test file
         ourTestWords = try! WordStore.getWords(file: filePath!)
        
        //create falling word mechanics
        fallingWordsMechanics = FallingWordsMechanics(words: ourTestWords!)
    }

    override func tearDown() {
        ourTestWords = nil
        fallingWordsMechanics = nil
    }
    
    func test_Init_SetsCorrectWords() {
        //test the word count
        XCTAssertEqual(fallingWordsMechanics!.words.count, ourTestWords!.count, "WordStore word count is invalid")
        
        //words of mechanics should be same as test data words
        XCTAssertEqual(fallingWordsMechanics!.words, ourTestWords, "WordStore words are not correct")
    }
    
    func test_NextTranslation_GivesCorrectTranslation() {
        //check for all tests words
        for word in ourTestWords! {
            //create translation from the word
            let ourTanslation = EngToSpan(word: word)
            
            //call method being tested
            //We force downcast because we specified EngToSpan type of translation while declaring property
            let nextTranslation = fallingWordsMechanics!.nextTranslation().0 as! EngToSpan
            
            //next translation should be same as our translation
            XCTAssertEqual(nextTranslation, ourTanslation, "next translation is not correct")
        }
    }
    
    func test_MatchingRightAnswerProbability_WorksCorrect() {
        //set probability to zero, means no wrong answer should ever fall
        fallingWordsMechanics!.maxConsecutiveWrongAns = 0
        
        let (translation, answer) = (fallingWordsMechanics!.nextTranslation())
        
        XCTAssertEqual(translation.translation, answer, "wrong answer should not be shown ")
    }
}
