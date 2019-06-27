//
//  Word.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

/// Model class for a word
struct Word: Codable {
    /// text in English
    var textEnglish: String
    
    /// text in Spanish
    var textSpanish: String
    
    //mapping for keys from JSON to Word struct
    enum CodingKeys: String, CodingKey {
        case textEnglish = "text_eng"
        case textSpanish = "text_spa"
    }
}

extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        if lhs.textEnglish !=  rhs.textEnglish {
            return false
        }

        if lhs.textSpanish !=  rhs.textSpanish {
            return false
        }
        
        return true
    }
}
