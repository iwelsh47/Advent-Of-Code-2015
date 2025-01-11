//
//  Day15.swift
//  AoC2015
//
//  Created by Ivan Welsh on 12/01/2025.
//

import Algorithms

struct CookieIngredient {
    let name: String
    let capacity: Int
    let durability: Int
    let flavor: Int
    let texture: Int
    let calories: Int
    
    init(from info: String) {
        let bits = info.components(separatedBy: .whitespaces)
        name = String(bits[0].dropLast())
        capacity = Int(bits[2].dropLast())!
        durability = Int(bits[4].dropLast())!
        flavor = Int(bits[6].dropLast())!
        texture = Int(bits[8].dropLast())!
        calories = Int(bits[10])!
    }
}

func allCombinations(of size: Int, sum target: Int) -> [[Int]] {
    if size == 1 {
        return [[target]]
    }
    var combos: [[Int]] = []
    for i in 0...target {
        let others = allCombinations(of: size - 1, sum: target - i)
            .map{ [i] + $0 }
        combos.append(contentsOf: others)
    }
    return combos
}

func runDay15() {
    let input = loadData(from: "Day15").components(separatedBy: .newlines)
    
    /*
     Today, you set out on the task of perfecting your milk-dunking cookie recipe. All you have to do is find the right
     balance of ingredients.
     
     Your recipe leaves room for exactly 100 teaspoons of ingredients. You make a list of the remaining ingredients you
     could use to finish the recipe (your puzzle input) and their properties per teaspoon:
     
     -  capacity (how well it helps the cookie absorb milk)
     -  durability (how well it keeps the cookie intact when full of milk)
     -  flavor (how tasty it makes the cookie)
     -  texture (how it improves the feel of the cookie)
     -  calories (how many calories it adds to the cookie)
     
     You can only measure ingredients in whole-teaspoon amounts accurately, and you have to be accurate so you can
     reproduce your results in the future. The total score of a cookie can be found by adding up each of the properties
     (negative totals become 0) and then multiplying together everything except calories.
     
     For instance, suppose you have these two ingredients:
     
     Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
     Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
     
     Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each
     ingredient must add up to 100) would result in a cookie with the following properties:
     
     -  A capacity of 44*-1 + 56*2 = 68
     -  A durability of 44*-2 + 56*3 = 80
     -  A flavor of 44*6 + 56*-2 = 152
     -  A texture of 44*3 + 56*-1 = 76
     
     Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of 62842880,
     which happens to be the best score possible given these ingredients. If any properties had produced a negative
     total, it would have instead become zero, causing the whole score to multiply to zero.
     
     Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie
     you can make?
     */
    let ingredients = input.map{ CookieIngredient(from: $0) }
    var highestScore = Int.min
    var highestScoreCalorieLimited = Int.min
    for amounts in allCombinations(of: ingredients.count, sum: 100) {
        var capacity = 0
        var durability = 0
        var flavor = 0
        var texture = 0
        var calories = 0
        
        for idx in 0..<ingredients.count {
            capacity += amounts[idx] * ingredients[idx].capacity
            durability += amounts[idx] * ingredients[idx].durability
            flavor += amounts[idx] * ingredients[idx].flavor
            texture += amounts[idx] * ingredients[idx].texture
            calories += amounts[idx] * ingredients[idx].calories
            
            let score = max(0, capacity) * max(0, durability) * max(0, flavor) * max(0, texture)
            if score > highestScore { highestScore = score }
            if calories == 500 && score > highestScoreCalorieLimited {
                highestScoreCalorieLimited = score
            }
        }
    }
    print("Part one solution: \(highestScore)")
    
    /*
     Your cookie recipe becomes wildly popular! Someone asks if you can make another recipe that has exactly 500
     calories per cookie (so they can use it as a meal replacement). Keep the rest of your award-winning process the
     same (100 teaspoons, same ingredients, same scoring system).
     
     For example, given the ingredients above, if you had instead selected 40 teaspoons of butterscotch and 60 teaspoons
     of cinnamon (which still adds to 100), the total calorie count would be 40*8 + 60*3 = 500. The total score would go
     down, though: only 57600000, the best you can do in such trying circumstances.
     
     Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie
     you can make with a calorie total of 500?
     */
    print("Part two solution: \(highestScoreCalorieLimited)")
}
