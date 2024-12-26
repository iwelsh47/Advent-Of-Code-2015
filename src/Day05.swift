//
//  Day05.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 25/12/2024.
//

func isNice(_ string: String) -> Bool {
    var vowelCount = 0
    var doubleLetterCount = 0
    var previousCharacter: Character = " "
    
    for character in string {
        if ["a", "e", "i", "o", "u"].contains(character) {
            vowelCount += 1
        }
        if character == previousCharacter {
            doubleLetterCount += 1
        }
        if ["ab", "cd", "pq", "xy"].contains("\(previousCharacter)\(character)") {
            return false
        }
        previousCharacter = character
    }
    return vowelCount >= 3 && doubleLetterCount >= 1
}

func isNicer(_ string: String) -> Bool {
    var repeatedCharacters: [String: Int] = [:]
    var letterPair = false
    var letterRepeat = false
    
    for idx in 0..<(string.count - 1) {
        let characterA = string[string.index(string.startIndex, offsetBy: idx)]
        let characterB = string[string.index(string.startIndex, offsetBy: idx + 1)]
        let repeated = "\(characterA)\(characterB)"
        if let repeatIdx = repeatedCharacters[repeated] {
            if (repeatIdx + 2) <= idx {
                letterPair = true
            }
        } else {
            repeatedCharacters.updateValue(idx, forKey: repeated)
        }
        
        if idx < string.count - 2 {
            let characterC = string[string.index(string.startIndex, offsetBy: idx + 2)]
            if characterC == characterA {
                letterRepeat = true
            }
        }
    }
    return letterRepeat && letterPair
}

func runDay05() {
    let input = loadData(from: "Day05")
    let strings = input.components(separatedBy: .whitespacesAndNewlines)
    
    /*
     Santa needs help figuring out which strings in his text file are naughty or nice.
     
     A nice string is one with all of the following properties:
     
     -  It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
     -  It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc,
     or dd).
     -  It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
     
     For example:
     
     -  ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and
     none of the disallowed substrings.
     -  aaa is nice because it has at least three vowels and a double letter, even though the letters used by different
     rules overlap.
     -  jchzalrnumimnmhp is naughty because it has no double letter.
     -  haegwjzuvuyypxyu is naughty because it contains the string xy.
     -  dvszwmarrgswjxmb is naughty because it contains only one vowel.
     
     How many strings are nice?
     */
    print("Part one solution: \(strings.filter{ isNice($0) }.count)")
    
    /*
     Realizing the error of his ways, Santa has switched to a better model of determining whether a string is naughty or
     nice. None of the old rules apply, as they are all clearly ridiculous.
     
     Now, a nice string is one with all of the following properties:
     
     -  It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy
     (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
     -  It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe),
     or even aaa.
     
     For example:
     
     -  qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly
     one letter between them (zxz).
     -  xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though
     the letters used by each rule overlap.
     -  uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
     -  ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears
     twice.
     
     How many strings are nice under these new rules?
     */
    print("Part two solution: \(strings.filter{ isNicer($0) }.count)")
}
