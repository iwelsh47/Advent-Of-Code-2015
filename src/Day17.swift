//
//  Day17.swift
//  AoC2015
//
//  Created by Ivan Welsh on 12/01/2025.
//

func knapsack(of items: [Int], to capacity: Int, idx: Int = 0) -> [[Int]] {
    if idx == items.count - 1 {
        return items[idx] == capacity ? [[items[idx]]] : []
    }
    var potentialArrangments: [[Int]] = []
    for i in idx..<items.count {
        let remainingCapacity = capacity - items[i]
        if remainingCapacity == 0 { potentialArrangments.append([items[i]]); continue }
        if remainingCapacity < 0 { continue }
        let remainingArrangments = knapsack(of: items, to: remainingCapacity, idx: i + 1)
        potentialArrangments.append(contentsOf: remainingArrangments.map{ $0 + [items[i]] })
    }
    
    return potentialArrangments
}

func runDay17() {
    let input = loadData(from: "Day17").components(separatedBy: .newlines).map{ Int($0)! }
    /*
     The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator, you'll need to
     move it into smaller containers. You take an inventory of the capacities of the available containers.
     
     For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there
     are four ways to do it:
     
     -  15 and 10
     -  20 and 5 (the first 5)
     -  20 and 5 (the second 5)
     -  15, 5, and 5
     
     Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of
     eggnog?
     */
    let waysToFillContainers = knapsack(of: input, to: 150)
    print("Part one solution: \(waysToFillContainers.count)")
    
    /*
     While playing with all the containers in the kitchen, another load of eggnog arrives! The shipping and receiving
     department is requesting as many containers as you can spare.
     
     Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many different ways can
     you fill that number of containers and still hold exactly 150 litres?
     
     In the example above, the minimum number of containers was two. There were three ways to use that many containers,
     and so the answer there would be 3.
     */
    let minimumCount = waysToFillContainers.map{ $0.count }.min()!
    print("Part two solution: \(waysToFillContainers.filter{ $0.count == minimumCount }.count)")
}
