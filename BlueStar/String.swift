//
//  String.swift
//  BlueStar
//
//  Created by tarun.kapil on 05/08/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import UIKit

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isNumeric: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    func getTitleCode() -> String {
        switch self {
        case TitleSelect.MS.rawValue:
            return "0001"
        case TitleSelect.MR.rawValue:
            return "0002"
        case TitleSelect.MISS.rawValue:
            return "0005"
        case TitleSelect.DR.rawValue:
            return "0006"
        default:
            return ""
        }
    }
    func getTitleForCode() -> String {
        switch self {
        case "0001":
            return TitleSelect.MS.rawValue
        case "0002":
            return TitleSelect.MR.rawValue
        case "0005":
            return TitleSelect.MISS.rawValue
        case "0006":
            return TitleSelect.DR.rawValue
        default:
            return ""
        }
    }
    
    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        //return !self.isEmpty && self.rangeOfCharacterFromSet(numberCharacters) == nil
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
}
/*public extension String {

    func isNumber() -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigitCharacterSet().invertedSet
        return !self.isEmpty && self.rangeOfCharacterFromSet(numberCharacters) == nil
    }

}*/
