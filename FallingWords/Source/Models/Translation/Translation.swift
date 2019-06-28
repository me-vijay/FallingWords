//
//  Translation.swift
//  FallingWords
//
//  Created by Vijay Kumar on 27/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

protocol Translation {
    /// word in String
    var word: String { get }
    
    /// translation in String
    var translation: String { get }
    
    /// initializer method that can create Translation object from Word object
    ///
    /// - Parameter word: object of type Word
    /// - Parameter tranlatingKey: name of key that identifies translation in Word object
    init(word: Word)
}

