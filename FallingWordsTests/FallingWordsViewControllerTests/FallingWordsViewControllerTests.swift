//
//  FallingWordsTests.swift
//  FallingWordsTests
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import XCTest
@testable import FallingWords

class FallingWordsViewControllerTests: XCTestCase {
    var viewController: FallingWordsViewController? = nil
    
    override func setUp() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        viewController = (storyBoard.instantiateViewController(withIdentifier: "FallingWordsViewController") as! FallingWordsViewController)
        let _ = viewController!.view
    }

    override func tearDown() {
        viewController = nil
    }
    
    func test_ViewDidLoad_InitializesViewModel() {
        XCTAssertNotNil(viewController?.viewModel, "ViewDidLoad should initialize ViewModel")
    }
    
    func test_ViewWillAppear_StartsGame() {
        // create mock viewmodel
        var mockViewModel = MockFallingWordsViewModel()
        
        // set controllers viewmodel as mock viewmodel
        viewController!.viewModel = mockViewModel
        
        // call view appearance method, so that ViewWillAppear will get called
        viewController!.beginAppearanceTransition(true, animated: true)
        viewController!.endAppearanceTransition()
        
        // viewmodel is struct, it was copied when passed to controller. To verify any changes, we need to get controllers copy of viewmodel
        mockViewModel = viewController?.viewModel as! MockFallingWordsViewModel
        
        // method starting the game must have been called
        XCTAssertTrue(mockViewModel.startGameWasCalled, "Game must start when View becomes visible ")
    }
    
    func test_SetInitialViewState_WorksCorrect() {
        let viewModel = viewController!.viewModel

        viewController!.setInitialViewState()

        XCTAssertEqual(viewController!.scoreLabel.text, "0", "Initial score label text is incorrect")
        XCTAssertEqual(viewController!.lifelinesLabel.text, String(viewModel!.lifelines), "Initial lifelines label text is incorrect")
        XCTAssertEqual(viewController!.counter, 10, "Initial counter value is incorrect")
        XCTAssertEqual(viewController!.counterLabel.text, String(viewController!.counter), "Initial countdown label text is incorrect")
        XCTAssertEqual(viewController?.translationLabel.numberOfLines, 0, "Initial translation label text is incorrect")
    }
    
    func test_BindViewModel_SetsCallblocks() {
        let viewModel = viewController!.viewModel
       
        viewController!.bindViewModel()
        
        XCTAssertNotNil(viewModel!.showWordTranslation, "showWordTranslation is not binded")
        XCTAssertNotNil(viewModel!.onScoreChange, "onScoreChange is not binded")
        XCTAssertNotNil(viewModel!.onLifelinesChange, "onLifelinesChange is not binded")
        XCTAssertNotNil(viewModel!.onGameOver, "onGameOver is not binded")
        XCTAssertNotNil(viewModel!.onGameCompletion, "onGameCompletion is not binded")
    }
    
    func test_ShowWord_SetsCorrectWord() {
        let testWord = "test word"
        
        viewController?.showWord(testWord)
        
        XCTAssertEqual(viewController!.wordLabel.text, testWord, "Word label text is not correct")
    }
    
    func test_showTranslation_SetsCorrectTranslation() {
        let testTranslation = "test translation"
        
        viewController!.showTranslation(testTranslation)
        
        XCTAssertEqual(viewController?.translationLabel.text, testTranslation, "Translation label text is not correct")
    }
    
    func test_showTranslation_SetsNewTimer() {
        let testTranslation = "test translation"
        let oldTimer = viewController!.timer
        
        viewController!.showTranslation(testTranslation)
        let newTimer = viewController!.timer!
        
        XCTAssertNotEqual(oldTimer, newTimer, "New timer should be used for new translation")
    }
    
    func test_SetGameOverView_SetsGameFinishState() {
        XCTAssertNil(viewController!.timer, "Initially timer should be nil because we haven't started game")
        
        //set timer manually
        viewController!.timer = Timer(fire: Date.distantFuture, interval: 1.0, repeats: true, block: { (timer) in
        })
        
        viewController!.setGameOverView()
        
        XCTAssertTrue(viewController!.translationLabel.isHidden, "Trasnlation label should be invisible when game ends")
        XCTAssertFalse(viewController!.timer!.isValid, "Timer should be invalid when game ends")
        XCTAssertEqual(viewController!.counter, 0, "Counter should be set to zero when game ends")
        XCTAssertEqual(viewController!.counterLabel.text, String(viewController!.counter), "Counter label text is incorrect when game ends")
    }
    
    func test_setGameCompletionView_SetsGameFinishState() {
        //set timer manually
        viewController!.timer = Timer(fire: Date.distantFuture, interval: 1.0, repeats: true, block: { (timer) in
        })
        
        viewController!.setGameCompletionView()
        
        XCTAssertTrue(viewController!.translationLabel.isHidden, "Trasnlation label should be invisible when game ends")
        XCTAssertFalse(viewController!.timer!.isValid, "Timer should be invalid when game ends")
        XCTAssertEqual(viewController!.counter, 0, "Counter should be set to zero when game ends")
        XCTAssertEqual(viewController!.counterLabel.text, String(viewController!.counter), "Counter label text is incorrect when game ends")

    }
    
    func test_NoButtonTapped_SetsUserAnswer() {
        var mockViewModel = MockFallingWordsViewModel()
        viewController!.viewModel = mockViewModel
        
        viewController!.noButtonTapped(self)
        mockViewModel = viewController!.viewModel as! MockFallingWordsViewModel
        
        XCTAssertFalse(mockViewModel.userAnswer!, "User selected no/wrong as answer")
    }
    
    func test_YesButtonTapped_SetsUserAnswer() {
        var mockViewModel = MockFallingWordsViewModel()
        viewController!.viewModel = mockViewModel
        
        viewController!.yesButtonTapped(self)
        mockViewModel = viewController!.viewModel as! MockFallingWordsViewModel
        
        XCTAssertTrue(mockViewModel.userAnswer!, "User selected yes/right as answer")
    }
    
    func test_WordReachedBottomGetsCalled_WhenCounterValueLessThanZero() {
        var mockViewModel = MockFallingWordsViewModel()
        viewController!.viewModel = mockViewModel

        viewController!.counter = -1
        
        mockViewModel = viewController!.viewModel as! MockFallingWordsViewModel
        
        XCTAssertTrue(mockViewModel.wordReachedBottomWasCalled, "When countdowns is finished, view model should be notified by calling wordReachedBottom")
    }
}

struct MockFallingWordsViewModel: FallingWordsViewModelProtocol {
    var startGameWasCalled = false
    var wordReachedBottomWasCalled = false
    var userAnswer: Bool? = nil
    
    var gameMechanics: GameMechanics  {
        //file path of test words
        let bundle = Bundle(for: type(of: self) as! AnyClass)
        let filePath = bundle.path(forResource: "test_words", ofType: "json")
        
        //read using our own method from test file
        let ourTestWords = try! WordStore.getWords(file: filePath!)
        
        //create falling word mechanics
        return FallingWordsMechanics<EngToSpan>(words: ourTestWords)!
    }
    
    var currentWordAndTranslation: (Translation, String)? { return nil }
    
    var lifelines: Int = 0
    
    var score: Int = 0
    
    var showWordTranslation: ((String, String) -> Void)?
    
    var onScoreChange: ((Int) -> Void)?
    
    var onLifelinesChange: ((Int) -> Void)?
    
    var onGameOver: (() -> Void)?
    
    var onGameCompletion: (() -> Void)?
    
    mutating func start() {
        startGameWasCalled = true
    }
    
    mutating func wordReachedBottom() {
        wordReachedBottomWasCalled = true
    }
    
    mutating func userAnswered(as choice: Bool) {
        userAnswer = choice
    }
}
