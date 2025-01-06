//
//  Day11.swift
//  AoC2015
//
//  Created by Ivan Welsh on 06/01/2025.
//

struct EightCharacterPassword {
    static let nextCharacter: [Character: Character] = [
        "a": "b", "b": "c", "c": "d", "d": "e", "e": "f", "f": "g", "g": "h", "h": "i", "i": "j", "j": "k", "k": "l",
        "l": "m", "m": "n", "n": "o", "o": "p", "p": "q", "q": "r", "r": "s", "s": "t", "t": "u", "u": "v", "v": "w",
        "w": "x", "x": "y", "y": "z", "z": "a"
    ]
    static let increasingTriples: [String] = [
        "abc", "bcd", "cde", "def", "efg", "fgh", "ghi", "hij", "ijk", "jkl", "klm", "lmn", "mno", "nop", "opq", "pqr",
        "qrs", "rst", "stu", "tuv", "uvi", "vwx", "wxy", "xyz"
    ]
    var characters: [Character]
    
    init(from string: String) {
        self.characters = Array(string)
    }
    
    init(from characters: [Character]) {
        self.characters = characters
    }
    
    func increment() -> EightCharacterPassword {
        var characters = self.characters
        var idx = characters.count - 1
        while idx >= 0 {
            characters[idx] = EightCharacterPassword.nextCharacter[characters[idx]]!
            if characters[idx] != "a" {
                break
            }
            idx -= 1
        }
        return EightCharacterPassword(from: characters)
    }
    
    func isValid() -> Bool {
        // No i, o, l
        if characters.filter({ $0 == "i" || $0 == "o" || $0 == "l" }).isNotEmpty {
            return false
        }
        
        // Double letters
        var doubleLetterCounts = 0
        var idx = 0
        while idx < characters.count - 1 {
            if characters[idx] == characters[idx + 1] {
                doubleLetterCounts += 1
                idx += 1
            }
            idx += 1
        }
        
        if doubleLetterCounts < 2 {
            return false
        }
        // Increasing straight
        let string = self.string
        return EightCharacterPassword.increasingTriples.filter({ string.contains($0) }).isNotEmpty
    }
    
    var string: String {
        get {
            characters.map{ "\($0)" }.joined()
        }
    }
}

func runDay11() {
    let input = loadData(from: "Day11")
    
    /*
     Santa's previous password expired, and he needs help choosing a new one.
     
     To help him remember his new password after the old one expires, Santa has devised a method of coming up with a
     password based on the previous one. Corporate policy dictates that passwords must be exactly eight lowercase
     letters (for security reasons), so he finds his new password by incrementing his old password string repeatedly
     until it is valid.
     
     Incrementing is just like counting with numbers: xx, xy, xz, ya, yb, and so on. Increase the rightmost letter one
     step; if it was z, it wraps around to a, and repeat with the next letter to the left until one doesn't wrap around.
     
     Unfortunately for Santa, a new Security-Elf recently started, and he has imposed some additional password
     requirements:
     
     -  Passwords must include one increasing straight of at least three letters, like abc, bcd, cde, and so on, up to
     xyz. They cannot skip letters; abd doesn't count.
     -  Passwords may not contain the letters i, o, or l, as these letters can be mistaken for other characters and are
     therefore confusing.
     -  Passwords must contain at least two different, non-overlapping pairs of letters, like aa, bb, or zz.
     
     For example:
     
     -  hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement
     requirement (because it contains i and l).
     -  abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.
     -  abbcegjk fails the third requirement, because it only has one double letter (bb).
     -  The next password after abcdefgh is abcdffaa.
     -  The next password after ghijklmn is ghjaabcc, because you eventually skip all the passwords that start with
     ghi..., since i is not allowed.
     
     Given Santa's current password (your puzzle input), what should his next password be?
     */
    var password = EightCharacterPassword(from: input)
    repeat {
        password = password.increment()
    } while !password.isValid()
    
    print("Part one solution: \(password.string)")
    
    repeat {
        password = password.increment()
    } while !password.isValid()
    print("Part two solution: \(password.string)")
    
}
