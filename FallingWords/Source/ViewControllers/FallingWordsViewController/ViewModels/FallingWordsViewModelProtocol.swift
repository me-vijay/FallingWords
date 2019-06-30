//
//  FallingWordsViewModelProtocol.swift
//  FallingWords
//
//  Created by Vijay Kumarvijay on 30/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation
protocol FallingWordsViewModelProtocol {
    /// game mechanics to get the translations
    var gameMechanics: GameMechanics { get }

    /// current word-translation. Nil when game not started or game over
    var currentWordAndTranslation: (Translation, String)? { get }
    
    /// lifelines of user. Default value is as set in AppConstants
    var lifelines: Int { get set }
    
    /// score of user
    var score: Int { get }
    
    /// codeblock to show word-translation on view
    var showWordTranslation: ((_ word: String, _ translation: String) -> Void)? { get set}
    
    /// codeblock called when user score changes
    var onScoreChange: ((_ score: Int) -> Void)? { get set}
    
    /// codeblock called when user lifelines change
    var onLifelinesChange: ((_ remainingLifelines: Int) -> Void)? { get set}
    
    /// codeblock called when game is over
    var onGameOver: (() -> Void)? { get set}
    
    /// codeblock called when user game is complete i.e. user has answered all words of store
    var onGameCompletion: (() -> Void)? { get set}

    /// method to start the game
    mutating func start()
    
    /// method to be called when word has reached the bottom of screen and user has not answered
    mutating func wordReachedBottom()

    /// method to process answer given by user
    ///
    /// - Parameter choice: Bool to represent user selected yes/right or no/wrong
    mutating func userAnswered(as choice: Bool)
}
