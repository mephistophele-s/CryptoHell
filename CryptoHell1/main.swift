//
//  main.swift
//  CryptoHell1
//
//  Created by Anastasia on 10/15/18.
//  Copyright © 2018 Anastasia. All rights reserved.
//

import Foundation

/* Task itself */
// print(task.base64Decoded()?.base64Decoded() ?? "")

/* Task 1 */
// print(caesarCiphered.caesarDeciphered())

/* Task 2 */
// let data = Data(fromHexEncodedString: vigenereCiphered)!
// let vigenereDehexed = String(data: data, encoding: .isoLatin1)!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
// print(vigenereDehexed.vigenereDeciphered())

/* Task 3 */
//print(substitutionCiphered.substitutionDeciphered())

var solutions = ["Meow" : 4, "WOF" : 2, "KAR" : 3]

print(solutions.shuffled().sorted { $0.value < $1.value }.first!.key)

