//
//  Day18.swift
//  AoC2015
//
//  Created by Ivan Welsh on 13/01/2025.
//

struct HundredSquare {
    let state: [Bool]
    
    init(from stateString: String, broken: Bool = false) {
        var state = Array(repeating: false, count: 100 * 100)
        for (index, char) in stateString.enumerated() {
            state[index] = char == "#"
        }
        
        if broken {
            state[0 + 0 * 100] = true
            state[99 + 0 * 100] = true
            state[0 + 99 * 100] = true
            state[99 + 99 * 100] = true
        }
        
        self.state = state
    }
    
    init(from grid: [Bool]) {
        self.state = grid
    }
    
    subscript(x: Int, y: Int) -> Bool? {
        guard x >= 0 && x < 100 && y >= 0 && y < 100 else { return nil }
        let idx = x + y * 100
        return state[idx]
    }
    
    func nextState(broken: Bool = false) -> HundredSquare {
        var nextState = Array(repeating: false, count: 100 * 100)
        if broken {
            nextState[0 + 0 * 100] = true
            nextState[99 + 0 * 100] = true
            nextState[0 + 99 * 100] = true
            nextState[99 + 99 * 100] = true
        }
        
        for x in 0..<100 {
            for y in 0..<100 {
                let neighbours = [self[x-1, y-1], self[x-1, y], self[x-1, y+1],
                                  self[x, y-1],                 self[x, y+1],
                                  self[x+1, y-1], self[x+1, y], self[x+1, y+1]].filter{ $0 == true }
                
                let idx = x + y * 100
                
                if self[x, y]! && neighbours.count >= 2 && neighbours.count <= 3 {
                    nextState[idx] = true
                } else if !self[x, y]! && neighbours.count == 3 {
                    nextState[idx] = true
                }
            }
        }
        return HundredSquare(from: nextState)
    }
    
}

func runDay18() {
    let input = loadData(from: "Day18").components(separatedBy: .newlines).joined()
    /*
     After the million lights incident, the fire code has gotten stricter: now, at most ten thousand lights are allowed.
     You arrange them in a 100x100 grid.
     
     Never one to let you down, Santa again mails you instructions on the ideal lighting configuration. With so few
     lights, he says, you'll have to resort to animation.
     
     Start by setting your lights to the included initial configuration (your puzzle input). A # means "on", and a .
     means "off".
     
     Then, animate your grid in steps, where each step decides the next configuration based on the current one. Each
     light's next state (either on or off) depends on its current state and the current states of the eight lights
     adjacent to it (including diagonals). Lights on the edge of the grid might have fewer than eight neighbors; the
     missing ones always count as "off".
     
     For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1 through 8, and the light
     marked B, which is on an edge, only has the neighbors marked 1 through 5:
     
     1B5...
     234...
     ......
     ..123.
     ..8A4.
     ..765.
     
     The state a light should have next is based on its current state (on or off) plus the number of neighbors that are
     on:
     
     -  A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
     -  A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.
     
     All of the lights update simultaneously; they all consider the same current state before moving to the next.
     
     Here's a few steps from an example configuration of another 6x6 grid:
     
     Initial state:
     .#.#.#
     ...##.
     #....#
     ..#...
     #.#..#
     ####..
     
     After 1 step:
     ..##..
     ..##.#
     ...##.
     ......
     #.....
     #.##..
     
     After 2 steps:
     ..###.
     ......
     ..###.
     ......
     .#....
     .#....
     
     After 3 steps:
     ...#..
     ......
     ...#..
     ..##..
     ......
     ......
     
     After 4 steps:
     ......
     ......
     ..##..
     ..##..
     ......
     ......
     After 4 steps, this example has four lights on.
     
     In your grid of 100x100 lights, given your initial configuration, how many lights are on after 100 steps?
     */
    var lightGrid = HundredSquare(from: input)
    for _ in 1...100 {
        lightGrid = lightGrid.nextState()
    }
    print("Part one solution: \(lightGrid.state.filter{$0}.count)")
    
    /*
     You flip the instructions over; Santa goes on to point out that this is all just an implementation of Conway's Game
     of Life. At least, it was, until you notice that something's wrong with the grid of lights you bought: four lights,
     one in each corner, are stuck on and can't be turned off. The example above will actually run like this:
     
     Initial state:
     ##.#.#
     ...##.
     #....#
     ..#...
     #.#..#
     ####.#
     
     After 1 step:
     #.##.#
     ####.#
     ...##.
     ......
     #...#.
     #.####
     
     After 2 steps:
     #..#.#
     #....#
     .#.##.
     ...##.
     .#..##
     ##.###
     
     After 3 steps:
     #...##
     ####.#
     ..##.#
     ......
     ##....
     ####.#
     
     After 4 steps:
     #.####
     #....#
     ...#..
     .##...
     #.....
     #.#..#
     
     After 5 steps:
     ##.###
     .##..#
     .##...
     .##...
     #.#...
     ##...#
     
     After 5 steps, this example now has 17 lights on.
     
     In your grid of 100x100 lights, given your initial configuration, but with the four corners always in the on state,
     how many lights are on after 100 steps?
     */
    lightGrid = HundredSquare(from: input, broken: true)
    for _ in 1...100 {
        lightGrid = lightGrid.nextState(broken: true)
    }
    print("Part two solution: \(lightGrid.state.filter{$0}.count)")
}
