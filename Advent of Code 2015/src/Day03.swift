//
//  Day03.swift
//  Advent of Code
//
//  Created by Ivan Welsh on 24/12/2024.
//

struct GridPoint: Hashable {
    let x, y: Int
    
    func move(_ direction: Character) -> Self {
        switch direction {
            case "^": return .init(x: x, y: y + 1)
            case "v": return .init(x: x, y: y - 1)
            case ">": return .init(x: x + 1, y: y)
            case "<": return .init(x: x - 1, y: y)
            default: return self
        }
    }
}

func runDay03() {
    let input = loadData(from: "Day03")
    
    /*
     Santa is delivering presents to an infinite two-dimensional grid of houses.
     
     He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls
     him via radio and tells him where to move next. Moves are always exactly one house to the north (^), south (v),
     east (>), or west (<). After each move, he delivers another present to the house at his new location.
     
     However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off,
     and Santa ends up visiting some houses more than once. How many houses receive at least one present?
     
     For example:
     
     -  > delivers presents to 2 houses: one at the starting location, and one to the east.
     -  ^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
     -  ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.
     */
    var currentLocation: GridPoint = .init(x: 0, y: 0)
    var visitedCounts: [GridPoint: Int] = [currentLocation: 1]
    
    for direction in input {
        currentLocation = currentLocation.move(direction)
        visitedCounts[currentLocation, default: 0] += 1
    }
    print("Part one solution: \(visitedCounts.count)")
    
    /*
     The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to deliver presents
     with him.
     
     Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), then take
     turns moving based on instructions from the elf, who is eggnoggedly reading from the same script as the previous
     year.
     
     This year, how many houses receive at least one present?
     
     For example:
     
     -  ^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
     -  ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
     -  ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa going the other.
     */
    var santaLocation: GridPoint = .init(x: 0, y: 0)
    var roboSantaLocation: GridPoint = .init(x: 0, y: 0)
    visitedCounts = [santaLocation: 2]
    
    for direction in input.enumerated() {
        if direction.offset % 2 == 0 {
            roboSantaLocation = roboSantaLocation.move(direction.element)
            visitedCounts[roboSantaLocation, default: 0] += 1
        } else {
            santaLocation = santaLocation.move(direction.element)
            visitedCounts[santaLocation, default: 0] += 1
        }
    }
    print("Part two solution: \(visitedCounts.count)")
    
}
