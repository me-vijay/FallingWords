//
//  EngToSpan.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

/// struct to represent English to Spanish translation
struct EngToSpan: Translation {
    /// word in String
    private(set) var word: String
    
    /// translation in String
    private(set) var translation: String

    init(word: Word) {
        //set english text as actual word
        self.word = word.textEnglish
        
        //set spanish text as translation
        self.translation = word.textSpanish
    }
}

extension EngToSpan: Equatable {
    static func == (lhs: EngToSpan, rhs: EngToSpan) -> Bool {
        if lhs.word !=  rhs.word {
            return false
        }
        
        if lhs.translation !=  rhs.translation {
            return false
        }
        
        return true
    }
}
