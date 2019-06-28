//
//  File.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

protocol GameMechanics {
    associatedtype TranslationType: Translation
    
    /// initializer
    ///
    /// - Parameters:
    ///   - words: array of words
    init(words: [Word])
    
    /// method to get next word-translation
    ///
    /// - Returns: tuple of next translation and the answer(correct/wrong) to be shown
    mutating func nextTranslation() -> (TranslationType, String)
}
