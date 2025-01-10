//
//  Day12.swift
//  AoC2015
//
//  Created by Ivan Welsh on 06/01/2025.
//

struct Token {
    enum TokenType {
       case ArrayOpen, ArrayClose, ObjectOpen, ObjectClose, ItemSeparator, ObjectSeparator, Number, String
    }
    let value: Any?
    let type: TokenType
}

func tokenise(_ string: String) -> [Token] {
    func convertToToken(_ string: String, state: CurrentState) -> Token {
        if string == "[" { return Token(value: nil, type: .ArrayOpen) }
        if string == "]" { return Token(value: nil, type: .ArrayClose) }
        if string == "{" { return Token(value: nil, type: .ObjectOpen) }
        if string == "}" { return Token(value: nil, type: .ObjectClose) }
        if string == "," { return Token(value: nil, type: .ItemSeparator) }
        if string == ":" { return Token(value: nil, type: .ObjectSeparator) }
        if state == .Number {
            return Token(value: Int(string)!, type: .Number)
        }
        return Token(value: string, type: .String)
    }
    
    enum CurrentState {
        case Number, String, Other
    }
    var tokens: [Token] = []
    var token: [Character] = []
    var state: CurrentState = .Other
    
    for char in string {
        if ["[", "]", "{", "}", ":", ","].contains(char) {
            if token.isNotEmpty {
                tokens.append(convertToToken(token.map{String($0)}.joined(), state: state))
                token.removeAll(keepingCapacity: true)
            }
            state = .Other
            tokens.append(convertToToken("\(char)", state: state))
        } else if char.isNumber || char == "-" {
            if state != .Number && token.isNotEmpty {
                tokens.append(convertToToken(token.map{String($0)}.joined(), state: state))
                token.removeAll(keepingCapacity: true)
            }
            state = .Number
            token.append(char)
        } else if char == "\"" {
            if token.isNotEmpty {
                tokens.append(convertToToken(token.map{String($0)}.joined(), state: state))
                token.removeAll(keepingCapacity: true)
            }
            state = .String
        } else if char.isLetter {
            if state != .String && token.isNotEmpty {
                tokens.append(convertToToken(token.map{String($0)}.joined(), state: state))
                token.removeAll(keepingCapacity: true)
            }
            state = .String
            token.append(char)
        }
    }
    
    return tokens
}

struct JSONObject {
    enum Kind {
        case Array, Object, Number, String
    }
    let kind: Kind
    let value: Any?
    
    init(from tokens: [Token]) {
        let startIdx = [.ItemSeparator, .ObjectSeparator].contains(tokens.first!.type)
                    ? tokens.index(after: tokens.startIndex) : tokens.startIndex
        let startToken = tokens[startIdx]
        switch startToken.type {
            case .Number:
                self.kind = .Number
                self.value = startToken.value as! Int
            case .String:
                self.kind = .String
                self.value = startToken.value as! String
            case .ArrayOpen:
                self.kind = .Array
                
                var arrayValues: [JSONObject] = []
                var endIdx = tokens.index(after: startIdx)
                var itemStartIdx = endIdx
                var count = 1
                while count != 0 {
                    if tokens[endIdx].type == .ArrayClose || tokens[endIdx].type == .ObjectClose {
                        count -= 1
                    } else if tokens[endIdx].type == .ArrayOpen || tokens[endIdx].type == .ObjectOpen {
                        count += 1
                    } else if tokens[endIdx].type == .ItemSeparator && count == 1 {
                        arrayValues.append(JSONObject(from: tokens[itemStartIdx..<endIdx].map{$0}))
                        itemStartIdx = tokens.index(after: endIdx)
                    }
                    endIdx = tokens.index(after: endIdx)
                }
                arrayValues.append(JSONObject(from: tokens[itemStartIdx..<endIdx].map{$0}))
                self.value = arrayValues
                
            case .ObjectOpen:
                self.kind = .Object
                
                var objectValues: [String: JSONObject] = [:]
                var objectName = tokens[tokens.index(after: startIdx)].value as! String
                var itemStartIdx = tokens.index(startIdx, offsetBy: 2)
                var endIdx = itemStartIdx
                var count = 1
                while count != 0 {
                    if tokens[endIdx].type == .ArrayClose || tokens[endIdx].type == .ObjectClose {
                        count -= 1
                    } else if tokens[endIdx].type == .ArrayOpen || tokens[endIdx].type == .ObjectOpen {
                        count += 1
                    } else if tokens[endIdx].type == .ItemSeparator && count == 1 {
                        objectValues.updateValue(JSONObject(from: tokens[itemStartIdx..<endIdx].map{$0}), forKey: objectName)
                        itemStartIdx = tokens.index(endIdx, offsetBy: 2)
                        objectName = tokens[tokens.index(after: endIdx)].value as! String
                        endIdx = itemStartIdx
                    }
                    endIdx = tokens.index(after: endIdx)
                }
                objectValues.updateValue(JSONObject(from: tokens[itemStartIdx..<endIdx].map{$0}), forKey: objectName)
                self.value = objectValues
            default:
                self.kind = .Object
                self.value = nil
            
        }
    }
    
    func sumOfNumbers() -> Int {
        switch kind {
            case .Number: return value as! Int
            case .String: return 0
            case .Array:
                return (value as! [JSONObject]).reduce(0, { $0 + $1.sumOfNumbers() })
            case .Object:
                return (value as! [String: JSONObject]).reduce(0, { $0 + $1.value.sumOfNumbers() })
        }
    }
    
    func sumOfNumbers(ignoring toIgnore: String) -> Int {
        switch kind {
            case .Number: return value as! Int
            case .String: return 0
            case .Array:
                return (value as! [JSONObject]).reduce(0, { $0 + $1.sumOfNumbers(ignoring: toIgnore) })
            case .Object:
                for (_, v) in (value as! [String: JSONObject]) {
                    if v.kind == .String && v.value as! String == toIgnore {
                        return 0
                    }
                }
                return (value as! [String: JSONObject]).reduce(0, { $0 + $1.value.sumOfNumbers(ignoring: toIgnore) })
        }
    }
}

func runDay12() {
    let input = loadData(from: "Day12")
    
    /*
     Santa's Accounting-Elves need help balancing the books after a recent order. Unfortunately, their accounting
     software uses a peculiar storage format. That's where you come in.
     
     They have a JSON document which contains a variety of things: arrays ([1,2,3]), objects ({"a":1, "b":2}), numbers,
     and strings. Your first job is to simply find all of the numbers throughout the document and add them together.
     
     For example:
     
     -  [1,2,3] and {"a":2,"b":4} both have a sum of 6.
     -  [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
     -  {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
     -  [] and {} both have a sum of 0.
     
     You will not encounter any strings containing numbers.
     
     What is the sum of all numbers in the document?
     */
    let json = JSONObject(from: tokenise(input))
    print("Part one solution: \(json.sumOfNumbers())")
    
    /*
     Uh oh - the Accounting-Elves have realized that they double-counted everything red.
     
     Ignore any object (and all of its children) which has any property with the value "red". Do this only for objects
     ({...}), not arrays ([...]).
     
     -  [1,2,3] still has a sum of 6.
     -  [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
     -  {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
     -  [1,"red",5] has a sum of 6, because "red" in an array has no effect.
     */
    print("Part two solution: \(json.sumOfNumbers(ignoring: "red"))")
    
}
