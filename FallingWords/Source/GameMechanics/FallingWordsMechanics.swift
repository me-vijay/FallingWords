//
//  File.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

struct FallingWordsMechanics<T: Translation>: GameMechanics {
    /// array of words
    private (set) var words: [Word]
    
    /// boolean to identify if all words have been shown in game
    private (set) var wordsFinished: Bool
    
    /// matching answer is presented with reasonable probability. This is the number of max wrong answers that can be presented in a row. By default probability is 2.
    var maxConsecutiveWrongAns: Int = AppConstants.matchingProbability
    
    /// index of current word
    private var currentWordIndex = 0
    
    /// count to track wrong words shown
    private var wrongCount = 0
    
    /// failable initializer. Fails when words list is empty
    ///
    /// - Parameter words: array of words
    init?(words: [Word]) {
        // if words is empty, nil is returned
        guard !words.isEmpty else { return nil }
        
        //set words
        self.words = words
        
        // words are yet to be shown in game
        wordsFinished = false
    }

    /// method to get next word-translation
    ///
    /// - Returns: tuple of next translation and the answer(correct/wrong) to be shown
    mutating func nextTranslation() -> (Translation, String) {
        //check for word index to be within words count
        if currentWordIndex >= words.count {
            // all words have been presented
            wordsFinished = true
            
            //restart from first word
            currentWordIndex = 0
        }
        
        //create translation from next word
        let translation = T(word: words[currentWordIndex])
        
        //get answer to show
        let answer = answerToShowForWord(at: currentWordIndex)
        
        //increment current word index
        currentWordIndex = currentWordIndex + 1
        
        //return translation and falling answer to be shown
        return (translation, answer)
    }
    
    // MARK: - Private Methods
    /// method to get the falling answer to be shown
    ///
    /// - Returns: falling answer String`
    private mutating func answerToShowForWord(at index: Int) -> String {
        //translation of current word
        var wordTranslation = EngToSpan(word: words[index])
        
        if shouldShowWrongAns() == false {
            //show right answer
            return wordTranslation.translation
        } else {
            //get current word
            let currentWord = words[currentWordIndex]
            
            //get a wrong word
            var wrongWord = words.randomElement()
            
            //if wrong word is same as correct word, get new wrong word until it's different from correct word
            while currentWord == wrongWord { wrongWord = words.randomElement() }
            
            //create EngToSpan translation from the wrong word
            wordTranslation = EngToSpan(word: wrongWord!)
            
            //return the actual translation of word
            return wordTranslation.translation
        }
    }
    
    /// method to determine if wrong answer should be shown
    ///
    /// - Returns: true if wrong answer should be shown, false otherwise
    private mutating func shouldShowWrongAns() -> Bool {
        //random decision to show right/wrong falling answer
        var shouldShowWrong = Bool.random()
        
        //if going to show wrong ans
        if shouldShowWrong {
            //increment wrong count
            self.wrongCount = self.wrongCount + 1
            
            //dnt show wrong ans if we have shown max no. of consecutive wrong ans
            if (self.wrongCount > maxConsecutiveWrongAns) {
                //dnt show wrong ans
                shouldShowWrong = false
            }
        }
        
        //if next falling ans is not going to be correct, then reset wrong count
        if shouldShowWrong == false { self.wrongCount = 0 }
        
        return shouldShowWrong
    }

}
