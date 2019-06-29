//
//  FallingWordsViewModel.swift
//  FallingWords
//
//  Created by Vijay Kumar on 28/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

struct FallingWordsViewModel {
    
    /// game mechanics to get the translations
    private var gameMechanics: GameMechanics
    
    /// current word-translation. Nil when game not started or game over
    private(set) var currentWordAndTranslation: (Translation, String)? {
        didSet {
            guard let currentWordAndTranslation = currentWordAndTranslation else { return }
            // show on view
            showWordTranslation?(currentWordAndTranslation.0.word, currentWordAndTranslation.1)
        }
    }
   
    /// lifelines of user. Default value is as set in AppConstants
    private(set) var lifelines = AppConstants.lifelineCount {
        didSet {
            // if lifelines ended
            if lifelines <= 0 {
                // set current word-translation to nil
                currentWordAndTranslation = nil
                
                //game is over
                onGameOver?()
            }
            else {
                // update lifelines on view
                onLifelinesChange?(lifelines)
            }
        }
    }
    
    /// score of user
    private(set) var score = 0 {
        didSet { onScoreChange?(score) } // update score on view
    }
    
    /// failable initiliazer. fails if data file is not found
    /// - Parameters:
    ///   - bundle: Bundle where file exists. Default is Main Bundle
    ///   - fileName: name of file. Default is the one specified in AppConstants
    ///   - fileType: type of file. Default is the one specified in AppConstants
    /// - Throws: any error occured creating wordstore from data file
    init?(bundle:Bundle = Bundle.main, fileName: String = AppConstants.wordsFile.name, fileType: String = AppConstants.wordsFile.type) throws {
        // file should exist
        guard let filePath = bundle.path(forResource: fileName, ofType: fileType) else {
            return nil
        }
        
        //create word store from file
        let store = try WordStore(jsonFileAt: filePath)
        
        // create FallingWordsMechanics of English to Spanish translation
        guard let gameMechanics = FallingWordsMechanics<EngToSpan>(words: store.words) else { return nil }
        
        self.gameMechanics = gameMechanics
    }
    
    /// codeblock to show word-translation on view
    var showWordTranslation: ((_ word: String, _ translation: String) -> Void)?
    
    /// codeblock called when user score changes
    var onScoreChange: ((_ score: Int) -> Void)?
    
    /// codeblock called when user lifelines change
    var onLifelinesChange: ((_ remainingLifelines: Int) -> Void)?
    
    /// codeblock called when game is over
    var onGameOver: (() -> Void)?
    
    /// codeblock called when user game is complete i.e. user has answered all words of store
    var onGameCompletion: (() -> Void)?
   
    /// method to start the game
    mutating func start() {
        //show next translation
        setWordAndTranslation()
    }
    
    /// method to be called when word has reached the bottom of screen and user has not answered
    mutating func wordReachedBottom() {
        //user missed chance to answer, decrement lifeline
        decrementLifeline()
        
        //show the next word-translation
        setWordAndTranslation()
    }
    
    /// method to be called on user selects an answer
    ///
    /// - Parameter choice: Bool to represent user selected yes/right or no/wrong
    mutating func userAnswered(as choice: Bool) {
        // currentWordAndTranslation = nil means game has not started or is over. so nothing to evaluate as right/wrong
        guard currentWordAndTranslation != nil else { return }
        
        // evaluate answer of user
        guard let isRightAnswer = isRight(answer: choice) else { return }
        
        if  isRightAnswer {
            // increment score on correct answer
            incrementScore()
        }
        else {
            //decrement lifeline on wrong score
            decrementLifeline()
        }

        // show next word-translation
        setWordAndTranslation()
    }
   
    /// private method to get next word-translation and present on view
    private mutating func setWordAndTranslation() {
        // next word will be set if lifelines are not zero
        guard lifelines > 0 else { return }
        
        // get next translation
        currentWordAndTranslation = gameMechanics.nextTranslation()
        
        // check if words are finished
        if gameMechanics.wordsFinished == true {
            //call game completion block
            onGameCompletion?()
        }
    }

    /// method to check if a answer is right or wrong
    ///
    /// - Parameter answer: selected answer/choice
    /// - Returns: true if selected answer/choice is right, false if it's wrong
    private func isRight(answer: Bool) -> Bool? {
         guard let currentWordAndTranslation = currentWordAndTranslation else { return nil }
        
        // get actual translation of word
        let actualTranslation = currentWordAndTranslation.0.translation
        
        //get translation that was asked to user
        let askedTranslation = currentWordAndTranslation.1
        
        // is translation shown the correct one
        let isMatchingTranslation = (askedTranslation == actualTranslation)
        
        
        // if answer is same as isMatchingTranslation, then answer is correct, otherwise wrong
        return (answer == isMatchingTranslation)
    }
    
    /// method to increment score
    private mutating func incrementScore() {
        score = score + 5
    }
    
    // method to decrement lifeline
    private mutating func decrementLifeline() {
        lifelines = lifelines - 1
    }
}
