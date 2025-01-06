//
//  Day09.swift
//  AoC2015
//
//  Created by Ivan Welsh on 06/01/2025.
//

import Algorithms

func runDay09() {
    let input = loadData(from: "Day09").components(separatedBy: .newlines)
    
    /*
     Every year, Santa manages to deliver all of his presents in a single night.
     
     This year, however, he has some new locations to visit; his elves have provided him the distances between every
     pair of locations. He can start and end at any two (different) locations he wants, but he must visit each location
     exactly once. What is the shortest distance he can travel to achieve this?
     
     For example, given the following distances:
     
     London to Dublin = 464
     London to Belfast = 518
     Dublin to Belfast = 141
     
     The possible routes are therefore:
     
     Dublin -> London -> Belfast = 982
     London -> Dublin -> Belfast = 605
     London -> Belfast -> Dublin = 659
     Dublin -> Belfast -> London = 659
     Belfast -> Dublin -> London = 605
     Belfast -> London -> Dublin = 982
     
     The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.
     
     What is the distance of the shortest route?
     */
    var distances: [String: [String: Int]] = [:]
    for line in input {
        let bits = line.components(separatedBy: .whitespaces)
        let from = bits[0]
        let to = bits[2]
        let distance = Int(bits[4])!
        
        distances[from, default: [:]][to, default: 0] = distance
        distances[to, default: [:]][from, default: 0] = distance
    }
    let locations = Set(distances.keys)
    var shortestDistance = Int.max
    var longestDistance = Int.min
    for visitOrder in locations.permutations(ofCount: locations.count) {
        var visitDistance = 0
        var idx = 0
        while idx < visitOrder.count - 1 {
            visitDistance += distances[visitOrder[idx], default: [:]][visitOrder[idx + 1]]!
            idx += 1
        }
        shortestDistance = min(shortestDistance, visitDistance)
        longestDistance = max(longestDistance, visitDistance)
    }
    print("Part one solution: \(shortestDistance)")
    
    /*
     The next year, just to show off, Santa decides to take the route with the longest distance instead.
     
     He can still start and end at any two (different) locations he wants, and he still must visit each location exactly
     once.
     
     For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London -> Belfast.
     
     What is the distance of the longest route?
     */
    print("Part two solution: \(longestDistance)")
    
}
