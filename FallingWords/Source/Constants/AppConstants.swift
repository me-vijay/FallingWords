//
//  AppConstants.swift
//  FallingWords
//
//  Created by Vijay Kumar on 28/06/2019.
//  Copyright © 2019 Vijay. All rights reserved.
//

import Foundation

enum AppConstants {
    //no. max wrong answers in consecutive is 2
    public static var matchingProbability = 2
    
    /// name and type of the file of words
    public static var wordsFile: (name: String, type: String) = ("words", "json")
    
    /// count of user lifelines
    public static var lifelineCount = 5
}
