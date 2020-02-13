//
//  PerfectPaperPasswordsAlgorithm.swift
//  KeyGen
//
//  Created by Alejandro Leon Del Villar on 05/02/20.
//  Copyright © 2020 Alejandro Leon Del Villar. All rights reserved.
//

import Foundation
import CryptoKit

class PerfectPaperPasswordsAlgorithm {
    
    static let singleton = PerfectPaperPasswordsAlgorithm()
    let alphabet = "! # % + 2  3 4 5 6 7 8 9 : = ? @ A B C D E F G H J K L M N P R S T U V W X Y Z a b c d e f g h i j k m n o p q r s t u v w x y z"
    var key = SymmetricKey(size: .bits256)
    
    func runAlgorithm() -> [String]{
        let alphabetArray = alphabet.split(separator: " ")
        var page : [String] = []
        var counter : UInt128 = 0
        var stringPasswords : String = ""

        for index in 0...127 {
            counter = UInt128(index)
            let data = Data(bytes: &counter, count: MemoryLayout.size(ofValue: counter))
            let encryptedContent = try! AES.GCM.seal(data, using: key).combined!
            let intValueAes = encryptedContent.withUnsafeBytes { $0.load(as: UInt128.self) }
            let residuo : Int = Int(intValueAes % 64)
            stringPasswords.append(String(alphabetArray[residuo]))
        }
        page = stringPasswords.split(by: 4)
        return page
    }
    
    static func getCipheredArrays(from array: [String]) -> [[String]] {
        let factor = 4
        let horizontalIndicators: [String] = ["", "A", "B", "C", "D"]
        var cipheredArrays: [[String]] = [horizontalIndicators]
        let indicatorOffset = 1
        var currentArray: [String] = []
        array.forEach { value in
            if currentArray.count == 0 {
                currentArray.append("\(cipheredArrays.count)")
            }
            if currentArray.count < factor + indicatorOffset {
                currentArray.append(value)
            } else {
                let newSection = currentArray
                cipheredArrays.append(newSection)
                currentArray = []
                if currentArray.count == 0 {
                    currentArray.append("\(cipheredArrays.count)")
                }
                currentArray.append(value)
            }
        }
        if currentArray.count == factor + indicatorOffset {
            let newSection = currentArray
            cipheredArrays.append(newSection)
            currentArray = []
        }
        print(cipheredArrays)
        return cipheredArrays
    }
    
    func generateNewSymmetricKey(){
        key = SymmetricKey(size: .bits256)
    }
    
    func getLegibleSymmetricKey() -> String{
        let legibleSymmetrickey = key.withUnsafeBytes {
            return Data(Array($0)).base64EncodedString()
        }
        return legibleSymmetrickey
    }
}

