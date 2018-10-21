//
//  VigenereDecipher.swift
//  CryptoHell1
//
//  Created by Anastasia on 10/15/18.
//  Copyright © 2018 Anastasia. All rights reserved.
//

import Foundation

let vigenereCiphered = "1c41023f564b2a130824570e6b47046b521f3f5208201318245e0e6b40022643072e13183e51183f5a1f3e4702245d4b285a1b23561965133f2413192e571e28564b3f5b0e6b50042643072e4b023f4a4b24554b3f5b0238130425564b3c564b3c5a0727131e38564b245d0732131e3b430e39500a38564b27561f3f5619381f4b385c4b3f5b0e6b580e32401b2a500e6b5a186b5c05274a4b79054a6b67046b540e3f131f235a186b5c052e13192254033f130a3e470426521f22500a275f126b4a043e131c225f076b431924510a295f126b5d0e2e574b3f5c4b3e400e6b400426564b385c193f13042d130c2e5d0e3f5a086b52072c5c192247032613433c5b02285b4b3c5c1920560f6b47032e13092e401f6b5f0a38474b32560a391a476b40022646072a470e2f130a255d0e2a5f0225544b24414b2c410a2f5a0e25474b2f56182856053f1d4b185619225c1e385f1267131c395a1f2e13023f13192254033f13052444476b4a043e131c225f076b5d0e2e574b22474b3f5c4b2f56082243032e414b3f5b0e6b5d0e33474b245d0e6b52186b440e275f456b710e2a414b225d4b265a052f1f4b3f5b0e395689cbaa186b5d046b401b2a500e381d61"

class VigenereDecipher {
    
    func deciphered(text: String) -> String {
        
        var parts: [[Character]] = []
        guard let length = keyLength(text: text) else { return "I can't manage, sorry" }
        
        for i in 0..<length {
            let startIndex = text.index(text.startIndex, offsetBy: i)
            let substring = String(text.suffix(from: startIndex)).substring(every: length)
            let deciphered = substring.caesarDeciphered()
            parts.append(Array(deciphered))
        }
        
        var resultArray: [Character] = []
        for i in 0..<parts[0].count {
            for part in parts {
                guard i < part.count else { continue }
                resultArray.append(part[i])
            }
        }

        return String(resultArray)
    }
    
    private func keyLength(text: String) -> Int? {
        let threshold = 0.05
        var indexes: [Int : Double] = [:]
        
        for i in 1..<text.count {
            let newTextSuffix = text.substring(startIndex: 0, offset: i)
            let start = text.index(text.startIndex, offsetBy: i)
            let range = start..<text.endIndex
            let substring = text[range]
            let newText = String(substring) + newTextSuffix
            
            let indexOfCoincidence = self.indexOfCoincidence(first: text, second: newText)
            if indexOfCoincidence > threshold {
                indexes[i] = indexOfCoincidence
            }
        }
        guard let min = indexes.sorted(by: { $0.key < $1.key }).first else { return nil }
        return min.key
    }
}

private extension VigenereDecipher {
    
    func indexOfCoincidence(first: String, second: String) -> Double {
        var indexxx = 0
        for i in 0..<first.count {
            let index1 = first.index(first.startIndex, offsetBy: i)
            let index2 = second.index(second.startIndex, offsetBy: i)
            
            if first[index1] == second[index2] {
                indexxx += 1
            }
        }
        return Double(indexxx) / Double(first.count)
    }
}


