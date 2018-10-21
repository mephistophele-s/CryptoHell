//
//  String+Extentions.swift
//  CryptoHell1
//
//  Created by Anastasia on 10/21/18.
//  Copyright © 2018 Anastasia. All rights reserved.
//

import Foundation

extension String {
    
    func vigenereDeciphered() -> String {
        let decipher = VigenereDecipher()
        return decipher.deciphered(text: self)
    }
}

extension String {
    
    func substitutionDeciphered() -> String {
        let decipher = SubstitutionDecipher()
        return decipher.deciphered(text: self)
    }
}

extension String {
    
    func uniqueCharacters() -> String {
        let countedSet = NSCountedSet(array: self.map { $0 })
        return self.filter { countedSet.count(for: $0) == 1}
    }
    
    func countOfLetter(char: Character) -> Int {
        let countedSet = NSCountedSet(array: self.map { $0 })
        return countedSet.count(for: char)
    }
    
    func substring(startIndex: Int, offset: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(start, offsetBy: offset)
        let range = start..<end
        let substring = self[range]
        return String(substring)
    }
    
    func substring(every offset: Int) -> String {
        var result = ""
        for (index, char) in self.enumerated() {
            if index % 3 == 0 { result += String(char) }
        }
        return result
    }
    
    func makesSence() -> Bool {
        var validSymbols = 0
        let percentage = 0.9
        
        self.lowercased().forEach {
            if $0 == " " || ("a"..."z").contains($0) { validSymbols += 1 }
        }
        
        let rate = Double(validSymbols) / Double(self.count)
        return rate >= percentage
    }
}
