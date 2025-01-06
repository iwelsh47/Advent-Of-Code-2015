//
//  Day10.swift
//  AoC2015
//
//  Created by Ivan Welsh on 06/01/2025.
//

func applyLookAndSay(to input: String) -> String {
    var result = ""
    var count = 0
    var digit = input.first!
    var idx = input.startIndex
    while idx != input.endIndex {
        if input[idx] == digit {
            count += 1
        } else {
            result += String(count) + String(digit)
            count = 1
            digit = input[idx]
        }
        idx = input.index(after: idx)
    }
    result += String(count) + String(digit)
    return result
}

func runDay10() {
    let input = loadData(from: "Day10")
    
    /*
     Today, the Elves are playing a game called look-and-say. They take turns making sequences by reading aloud the
     previous sequence and using that reading as the next sequence. For example, 211 is read as "one two, two ones",
     which becomes 1221 (1 2, 2 1s).
     
     Look-and-say sequences are generated iteratively, using the previous value as input for the next step. For each
     step, take the previous value, and replace each run of digits (like 111) with the number of digits (3) followed by
     the digit itself (1).
     
     For example:
     
     -  1 becomes 11 (1 copy of digit 1).
     -  11 becomes 21 (2 copies of digit 1).
     -  21 becomes 1211 (one 2 followed by one 1).
     -  1211 becomes 111221 (one 1, one 2, and two 1s).
     -  111221 becomes 312211 (three 1s, two 2s, and one 1).
     
     Starting with the digits in your puzzle input, apply this process 40 times. What is the length of the result?
     */
    var result = input
    for _ in 0..<40 {
        result = applyLookAndSay(to: result)
    }
    print("Part one solution: \(result.count)")
    
    /*
     Neat, right? You might also enjoy hearing John Conway talking about this sequence (that's Conway of Conway's Game
     of Life fame).
     
     Now, starting again with the digits in your puzzle input, apply this process 50 times. What is the length of the
     new result?
     */
    for _ in 0..<10 {
        result = applyLookAndSay(to: result)
    }
    print("Part two solution: \(result.count)")
    
}
