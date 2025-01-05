//
//  Day04.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 24/12/2024.
//

import CryptoKit

func MD5leadingZeros(of hash: Insecure.MD5Digest, equals number: Int) -> Bool {
    let startingHash: [Int: [UInt8]] = [ 5: [0xFF, 0xFF, 0xF0],
                                         6: [0xFF, 0xFF, 0xFF]]
    
    return hash.enumerated()
        .allSatisfy{ ($0.offset < 3 && $0.element & startingHash[number]![$0.offset] == 0) || $0.offset >= 3 }
}

func runDay04() {
    let input = loadData(from: "Day04")
    
    /*
     Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically
     forward-thinking little girls and boys.
     
     To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the
     MD5 hash is some secret key (your puzzle input, given below) followed by a number in decimal. To mine AdventCoins,
     you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.
     
     For example:
     
     -  If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes
     (000001dbbfa...), and it is the lowest such number to do so.
     -  If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes
     is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....
     */
    var number = 1
    while !MD5leadingZeros(of: "\(input)\(number)".md5Raw(), equals: 5) {
        number += 1
    }
    print("Part one solution: \(number)")
    
    /*
     Now find one that starts with six zeroes.
     */
    while !MD5leadingZeros(of: "\(input)\(number)".md5Raw(), equals: 6) {
        number += 1
    }
    print("Part two solution: \(number)")
    
}
