//
//  Day07.swift
//  AoC2015
//
//  Created by Ivan Welsh on 26/12/2024.
//
import Foundation

class BitwiseGate {
    enum BitwiseOperation {
        case INPUT
        case AND
        case OR
        case LSHIFT
        case RSHIFT
        case NOT
        case ASSIGN
    }
    let name: String
    var operation: BitwiseOperation? = nil
    var leftSide: BitwiseGate? = nil
    var rightSide: BitwiseGate? = nil
    var value: UInt16? = nil
    
    init(named name: String) {
        self.name = name
    }
    
    func handleSetup(from bits: [String], data: inout [String: BitwiseGate]) {
        if bits.count == 3 {
            if let toAssign = UInt16(bits[0]) {
                value = toAssign
                operation = .INPUT
            } else {
                operation = .ASSIGN
                leftSide = data.getValueOrConstruct(forKey: bits[0], defaultValue: BitwiseGate(named: bits[0]))
            }
        } else if bits.count == 4 {
            operation = .NOT
            rightSide = data.getValueOrConstruct(forKey: bits[1], defaultValue: BitwiseGate(named: bits[1]))
        } else {
            switch bits[1] {
                case "AND": operation = .AND
                case "OR": operation = .OR
                case "LSHIFT": operation = .LSHIFT
                case "RSHIFT": operation = .RSHIFT
                default: fatalError("Unknown operation \(bits[1])")
            }
            if let fixedValue = UInt16(bits[0]) {
                value = fixedValue
                rightSide = data.getValueOrConstruct(forKey: bits[2], defaultValue: BitwiseGate(named: bits[2]))
            } else if let fixedValue = UInt16(bits[2]) {
                value = fixedValue
                leftSide = data.getValueOrConstruct(forKey: bits[0], defaultValue: BitwiseGate(named: bits[0]))
            } else {
                leftSide = data.getValueOrConstruct(forKey: bits[0], defaultValue: BitwiseGate(named: bits[0]))
                rightSide = data.getValueOrConstruct(forKey: bits[2], defaultValue: BitwiseGate(named: bits[2]))
            }
            
        }
        
        data[name] = self
    }
    
    func computeSignal(_ cache: inout [String: UInt16]) -> UInt16 {
        // Calculate left and right signals, using the cache
        var leftSignal: UInt16? = nil
        var rightSignal: UInt16? = nil
        
        if leftSide != nil {
            if let tmp = cache[leftSide!.name] { leftSignal = tmp }
            else {
                leftSignal = leftSide!.computeSignal(&cache)
                cache[leftSide!.name] = leftSignal
            }
        }
        if rightSide != nil {
            if let tmp = cache[rightSide!.name] { rightSignal = tmp }
            else {
                rightSignal = rightSide!.computeSignal(&cache)
                cache[rightSide!.name] = rightSignal
            }
        }
        
        switch operation! {
            case .INPUT: return value!
            case .ASSIGN: return leftSignal!
            case .NOT: return ~rightSignal!
            case .AND:
                if leftSide == nil { return value! & rightSignal! }
                if rightSide == nil { return leftSignal! & value! }
                return leftSignal! & rightSignal!
            case .OR:
                if leftSide == nil { return value! | rightSignal! }
                if rightSide == nil { return leftSignal! | value! }
                return leftSignal! | rightSignal!
            case .LSHIFT: return leftSignal! << value!
            case .RSHIFT: return leftSignal! >> value!
        }
    }
}

func runDay07() {
    let input = loadData(from: "Day07").components(separatedBy: .newlines)
//    let input = [
//        "123 -> x",
//        "y RSHIFT 2 -> g",
//        "456 -> y",
//        "x AND y -> d",
//        "x LSHIFT 2 -> f",
//        "NOT x -> h",
//        "x OR y -> e",
//        "NOT y -> i"
//    ]
    var instructions: [String: BitwiseGate] = [:]
    for instruction in input {
        let bits = instruction.components(separatedBy: .whitespaces)
        let gate = instructions.getValueOrConstruct(forKey: bits.last!, defaultValue: BitwiseGate(named: bits.last!))
        gate.handleSetup(from: bits, data: &instructions)
    }
    
    /*
     This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates! Unfortunately, little Bobby is
     a little under the recommended age range, and he needs help assembling the circuit.
     
     Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number from 0 to 65535). A
     signal is provided to each wire by a gate, another wire, or some specific value. Each wire can only get a signal
     from one source, but can provide its signal to multiple destinations. A gate provides no signal until all of its
     inputs have a signal.
     
     The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires
     x and y to an AND gate, and then connect its output to wire z.
     
     For example:
     
     -  123 -> x means that the signal 123 is provided to wire x.
     -  x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
     -  p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
     -  NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.
     -  Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to
     emulate the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide
     operators for these gates.
     
     For example, here is a simple circuit:
     
     123 -> x
     456 -> y
     x AND y -> d
     x OR y -> e
     x LSHIFT 2 -> f
     y RSHIFT 2 -> g
     NOT x -> h
     NOT y -> i
     After it is run, these are the signals on the wires:
     
     d: 72
     e: 507
     f: 492
     g: 114
     h: 65412
     i: 65079
     x: 123
     y: 456
     
     In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to
     wire a?
     */
    var computedSignals: [String: UInt16] = [:]
    let wireASignal = instructions["a"]!.computeSignal(&computedSignals)
    print("Part one solution: \(wireASignal)")
    
    /*
     Now, take the signal you got on wire a, override wire b to that signal, and reset the other wires (including wire
     a). What new signal is ultimately provided to wire a?
     */
    computedSignals = ["b": wireASignal ]
    print("Part two soluation: \(instructions["a"]!.computeSignal(&computedSignals))")
}
