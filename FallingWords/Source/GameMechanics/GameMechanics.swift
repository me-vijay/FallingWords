//
//  File.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

protocol GameMechanics {
    /// boolean to identify if all words have been shown in game
    var wordsFinished: Bool { get }
    
    /// failable initializer
    ///
    /// - Parameters:
    ///   - words: array of words
    init?(words: [Word])
    
    /// method to get next word-translation
    ///
    /// - Returns: tuple of next translation and the answer(correct/wrong) to be shown.
    /// when all words have been returned, this would return same words again.
    /// Use wordsFinished Bool to check if all words have been processed in game
    mutating func nextTranslation() -> (Translation, String)
}
