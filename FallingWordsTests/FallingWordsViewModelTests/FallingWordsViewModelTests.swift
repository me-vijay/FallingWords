//
//  FallingWordsViewModelTests.swift
//  FallingWordsTests
//
//  Created by Vijay Kumar on 28/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import XCTest
@testable import FallingWords

class FallingWordsViewModelTests: XCTestCase {
    
    var viewModel: FallingWordsViewModel!
    
    override func setUp() {
        viewModel = try! FallingWordsViewModel(bundle: Bundle(for: type(of: self)), fileName: "test_words", fileType: "json")
    }

    override func tearDown() {
        viewModel = nil
    }
    
    func test_Start_CallsWordTranslationBlock() {
        let expectation = XCTestExpectation(description: "WordTranslationBlock")
        var blockWasCalled = false
        
        viewModel.showWordTranslation = { (word, translation) in
            blockWasCalled = true
            expectation.fulfill()
        }
        
        viewModel.start()
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(blockWasCalled, "starting game doesn't call showWordTranslation")
    }

    func test_Start_SetsCurentWordTranslation() {
        viewModel.start()
        
        let wordAndTranslation = viewModel.currentWordAndTranslation
        
        XCTAssertNotNil(wordAndTranslation, "WordAndTranslation should not be nil after game is started")
    }

    func test_WordReachedBottom_DecrementsLifelines() {
        let previousLifelines =  viewModel.lifelines
        var expectedLifelines: Int = 0
        let expectation = XCTestExpectation(description: "LifelinesBlock")
        
        viewModel.onLifelinesChange = { (remainingLifelines) in
            expectedLifelines = remainingLifelines
            expectation.fulfill()
        }
        
        viewModel.wordReachedBottom()
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(expectedLifelines, previousLifelines - 1,   "Missing a word should decrement a lifeline")
    }
    
    func test_WordReachedBottom_ShowsNextWord() {
        let expectation = XCTestExpectation(description: "LifelinesBlock")
        var blockWasCalled = false
        
        XCTAssertTrue(viewModel.lifelines > 0, "Lifelines should be present before proceeding")
        
        viewModel.showWordTranslation = { (word, translation) in
            blockWasCalled = true
            expectation.fulfill()
        }
        
        viewModel.wordReachedBottom()
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(blockWasCalled, "New word should show after a word is missed")
    }
    
    func test_UserAnswered_RightAnswerIncrementsScore() {
        let oldScore = viewModel.score
        let expectation = XCTestExpectation(description: "ScoreChangeBlock")
        var newScore: Int = 0
        
        viewModel.onScoreChange = { (score) in
            newScore = score
            expectation.fulfill()
        }
        
        viewModel.selectRightAnswer(true)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(newScore > oldScore, "Right ansnwer should increase score")
    }
    
    func test_UserAnswered_WrongAnswerDecrementsLifeline() {
        let oldLifelines = viewModel.lifelines
        var newLifelines: Int = 0
        let expectation = XCTestExpectation(description: "LifelineChangeBlock")
        
        viewModel.onLifelinesChange = { (remainingLifelines) in
            newLifelines = remainingLifelines
            expectation.fulfill()
        }
        viewModel.selectRightAnswer(false)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(newLifelines, oldLifelines - 1, "Wrong ansnwer should decrement a lifeline")
    }

    func test_UserAnswered_RightAnswerShowsNextWord() {
        // call start to get a question to answer
        viewModel.start()
        
        let expectation = XCTestExpectation(description: "WordTranslationBlock")
        var blockWasCalled = false
        
        viewModel.showWordTranslation = { (word, translation) in
            blockWasCalled = true
            expectation.fulfill()
        }

        //answer the question generated at start of game
        viewModel.selectRightAnswer(true)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(blockWasCalled, "Right ansnwer should present next word")
    }
    
    func test_UserAnswered_WrongAnswerShowsNextWord() {
        // call start to get a question to answer
        viewModel.start()

        let expectation = XCTestExpectation(description: "WordTranslationBlock")
        var blockWasCalled = false

        viewModel.showWordTranslation = { (word, translation) in
            blockWasCalled = true
            expectation.fulfill()
        }

        viewModel.selectRightAnswer(false)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(blockWasCalled, "Wrong ansnwer should present next word")
    }
    
    func test_LoosingAllLifelines_CallsGameOver() {
        //start game
        viewModel.start()
        let expectation = XCTestExpectation(description: "GameOverBlock")
        var blockWasCalled = false
        
        viewModel.onGameOver = {
            blockWasCalled = true
            expectation.fulfill()
        }
        
        for _ in 1...viewModel.lifelines {
            viewModel.selectRightAnswer(false)
        }
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(blockWasCalled, "Game should end after giving max wrong answers")
    }
    
    func test_GivingAllCorrectAnswers_CallsGameCompletion() {
        // get the words, with which viewmodel is initialized
        let bundle = Bundle(for: type(of: self))
        let filePath = bundle.path(forResource: "test_words", ofType: "json")
        let ourTestWords = try! WordStore.getWords(file: filePath!)

        // start game
        viewModel.start()
        let expectation = XCTestExpectation(description: "GameCompletionBlock")
        var blockWasCalled = false
        
        viewModel.onGameCompletion = {
            blockWasCalled = true
            expectation.fulfill()
        }
        
        //answer all words
        for _ in ourTestWords {
            viewModel.selectRightAnswer(true)
        }
        
        wait(for: [expectation], timeout: 2)
        XCTAssertTrue(blockWasCalled, "Game should be completed after giving all right answers")
    }
}

extension FallingWordsViewModel {
    mutating func selectRightAnswer(_ right: Bool) {
        self.start()
        let wordAndTranslation = self.currentWordAndTranslation

        var rightChoice = (wordAndTranslation?.0.translation == wordAndTranslation?.1)
        
        if right == false {
            rightChoice = !rightChoice
        }
        
        self.userAnswered(as: rightChoice)
    }
}
