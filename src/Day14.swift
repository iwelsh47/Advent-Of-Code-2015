//
//  Day14.swift
//  AoC2015
//
//  Created by Ivan Welsh on 11/01/2025.
//

struct SpeedyReindeer {
    let name: String
    let speed: Int
    let speedTime: Int
    let restTime: Int
    
    init(from data: String) {
        let bits = data.components(separatedBy: .whitespaces)
        name = String(bits[0])
        speed = Int(bits[3])!
        speedTime = Int(bits[6])!
        restTime = Int(bits[13])!
    }
    
    func distance(at time: Int) -> Int {
        let cycletime = speedTime + restTime
        let cycleDistance = speed * speedTime
        let (cycles, remainder) = time.quotientAndRemainder(dividingBy: cycletime)
        return cycleDistance * cycles + min(remainder, speedTime) * speed
    }
}

func runDay14() {
    let input = loadData(from: "Day14").components(separatedBy: .newlines)
    
    /*
     This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must rest occasionally to recover their
     energy. Santa would like to know which of his reindeer is fastest, and so he has them race.
     
     Reindeer can only either be flying (always at their top speed) or resting (not moving at all), and always spend
     whole seconds in either state.
     
     For example, suppose you have the following Reindeer:
     
     -  Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
     -  Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
     After one second, Comet has gone 14 km, while Dancer has gone 16 km. After ten seconds, Comet has gone 140 km,
     while Dancer has gone 160 km. On the eleventh second, Comet begins resting (staying at 140 km), and Dancer
     continues on for a total distance of 176 km. On the 12th second, both reindeer are resting. They continue to rest
     until the 138th second, when Comet flies for another ten seconds. On the 174th second, Dancer flies for another 11
     seconds.
     
     In this example, after the 1000th second, both reindeer are resting, and Comet is in the lead at 1120 km (poor
     Dancer has only gotten 1056 km by that point). So, in this situation, Comet would win (if the race ended at 1000
     seconds).
     
     Given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, what distance has the
     winning reindeer traveled?
     */
    let reindeer = input.map{ SpeedyReindeer(from: $0) }
    var maxDistance = 0
    for deer in reindeer {
        let deerDistance = deer.distance(at: 2503)
        if deerDistance > maxDistance { maxDistance = deerDistance }
    }
    print("Part one solution: \(maxDistance)")
    
    /*
     Seeing how reindeer move in bursts, Santa decides he's not pleased with the old scoring system.
     
     Instead, at the end of each second, he awards one point to the reindeer currently in the lead. (If there are
     multiple reindeer tied for the lead, they each get one point.) He keeps the traditional 2503 second time limit, of
     course, as doing otherwise would be entirely ridiculous.
     
     Given the example reindeer from above, after the first second, Dancer is in the lead and gets one point. He stays
     in the lead until several seconds into Comet's second burst: after the 140th second, Comet pulls into the lead and
     gets his first point. Of course, since Dancer had been in the lead for the 139 seconds before that, he has
     accumulated 139 points by the 140th second.
     
     After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only has 312. So,
     with the new scoring system, Dancer would win (if the race ended at 1000 seconds).
     
     Again given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, how many points
     does the winning reindeer have?
     */
    var deerPoints: [String: Int] = [:]
    for second in 1...2503 {
        let secondDistances = reindeer.reduce(into: [:], { $0.updateValue($1.distance(at: second), forKey: $1.name)})
        let maxDistance = secondDistances.map{ $0.value }.max()
        for deer in reindeer {
            if secondDistances[deer.name] == maxDistance {
                deerPoints[deer.name, default: 0] += 1
            }
        }
    }
    print("Part two solution: \(deerPoints.map{$0.value}.max()!)")
    
}
