//
//  SubstitutionDecipher.swift
//  CryptoHell1
//
//  Created by Anastasia on 10/21/18.
//  Copyright © 2018 Anastasia. All rights reserved.
//

import Foundation

let substitutionCiphered = "EFFPQLEKVTVPCPYFLMVHQLUEWCNVWFYGHYTCETHQEKLPVMSAKSPVPAPVYWMVHQLUSPQLYWLASLFVWPQLMVHQLUPLRPSQLULQESPBLWPCSVRVWFLHLWFLWPUEWFYOTCMQYSLWOYWYETHQEKLPVMSAKSPVPAPVYWHEPPLUWSGYULEMQTLPPLUGUYOLWDTVSQETHQEKLPVPVSMTLEUPQEPCYAMEWWYOYULULTCYWPQLSEOLSVOHTLUYAPVWLYGDALSSVWDPQLNLCKCLRQEASPVILSLEUMQBQVMQCYAHUYKEKTCASLFPYFLMVHQLUHULIVYASHEUEDUEHQBVTTPQLVWFLRYGMYVWMVFLWMLSPVTTBYUNESESADDLSPVYWCYAMEWPUCPYFVIVFLPQLOLSSEDLVWHEUPSKCPQLWAOKLUYGMQEUEMPLUSVWENLCEWFEHHTCGULXALWMCEWETCSVSPYLEMQYGPQLOMEWCYAGVWFEBECPYASLQVDQLUYUFLUGULXALWMCSPEPVSPVMSBVPQPQVSPCHLYGMVHQLUPQLWLRPHEUEDUEHQMYWPEVWSSYOLHULPPCVWPLULSPVWDVWGYUOEPVYWEKYAPSYOLEFFVPVYWETULBEUF"


class SubstitutionDecipher {
    
    func deciphered(text: String) -> String {
        
        var iterationsCount = 0
        var deciphered = ""
        let probabilities = _probabilities()
        
        repeat {
            var key = _parent()
            deciphered = _deciphered(text: text, with: key)
            var fitness = _fitness(text: deciphered, probabilities: probabilities)
            while fitness < fitnessForEnglish && iterationsCount <= 1000 {
                let mutated = _mutated(key)
                let newDeciphered = _deciphered(text: text, with: mutated)
                let newFitness = _fitness(text: newDeciphered, probabilities: probabilities)
                if newFitness > fitness {
                    fitness = newFitness
                    key = mutated
                    deciphered = newDeciphered
                    print("New parent is \(key)")
                    print("New fitness is \(newFitness)")
                    print("Deciphered text is \(deciphered)")
                    iterationsCount = 0
                }
                iterationsCount += 1
            }
            if iterationsCount > 1000 {
                iterationsCount = 0
                continue
            } else { break }
        } while true
        
        return deciphered
    }
    
    private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".flatMap { $0.description }
    private let fitnessForEnglish = -147.0
}

private extension SubstitutionDecipher {
    
    func _fitness(text: String, probabilities: [String: Double]) -> Double {
        let quadrogramsFloor = log10(0.01 / Double(probabilities.count))
        var fitness = 0.0

        let quadrograms = _quadrograms(for: text)
        quadrograms.forEach {
            if let value = probabilities[$0.key] {
                fitness += value * Double($0.value)
            } else {
                fitness += quadrogramsFloor
            }
        }
        return fitness
    }
    
    func _quadrograms(for text: String) -> [String: Int] {
        var quadrograms: [String: Int] = [:]

        for i in 0..<text.count - 5 {
            let quadrogram = {
                return text.substring(startIndex: i, offset: 4)
            }()
            let count = text.components(separatedBy: quadrogram).count - 1
            quadrograms[quadrogram] = count
        }
        return quadrograms
    }
    
    func _mutated(_ key: [Character]) -> [Character] {
        var mutated = key
        let i = Int.random(in: (0..<key.count))
        var j: Int
        repeat {
            j = Int.random(in: (0..<key.count))
        } while j == i
        mutated.swapAt(i, j)
        return mutated
    }
    
    func _deciphered(text: String, with key: [Character]) -> String {
        let keyMap = _keyMap(from: key)
        var result: String = ""
        for letter in text {
            guard let deciphered = keyMap[letter] else { continue }
            result.append(deciphered)
        }
        return result
    }
    
    func _keyMap(from key: [Character]) -> [Character: Character] {
        var keyDictionary: [Character: Character] = [:]
        for (index, letter) in alphabet.enumerated() {
            keyDictionary[letter] = key[index]
        }
        return keyDictionary
    }
    
    func _parent() -> [Character] {
        let parent = alphabet.shuffled()
        return parent
    }
}

private extension SubstitutionDecipher {
    
    func _probabilities() -> [String: Double] {
        var probabilities: [String: Double] = [:]
        let dictionary = _dictionary()
        let count = dictionary.count
        for (key, value) in dictionary {
            probabilities[key] = log10(Double(value) / Double(count))
        }
        return probabilities
    }
    
    func _dictionary() -> [String: Int] {
        var dictionary: [String: Int] = [:]
        
        let filePath = "/Users/\(NSFullUserName())/Desktop/english_quadgrams.txt"
        let quadrograms = try! String(contentsOfFile: filePath).split(separator: "\n")
        
        quadrograms.forEach { str in
            let splitted = str.split(separator: " ")
            let key = String(splitted.first!)
            let value = Int(splitted.last!)!
            dictionary[key] = value
        }
        return dictionary
    }
}
