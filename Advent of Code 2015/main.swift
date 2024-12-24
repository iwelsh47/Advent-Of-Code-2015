//
//  main.swift
//  Advent of Code 2015
//
//  Created by Ivan Welsh on 24/12/2024.
//

import Foundation

extension String {
    func trimmed() -> String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
}

extension Array {
    public func splat() -> (Element,Element) {
        return (self[0],self[1])
    }
    
    public func splat() -> (Element,Element,Element) {
        return (self[0],self[1],self[2])
    }
    
    public func splat() -> (Element,Element,Element,Element) {
        return (self[0],self[1],self[2],self[3])
    }
    
    public func splat() -> (Element,Element,Element,Element,Element) {
        return (self[0],self[1],self[2],self[3],self[4])
    }
}

func loadData(from filename: String) -> String {
    let filePath = "Advent of Code 2015/data/\(filename)"
    do {
        let contents = try String(contentsOfFile: filePath, encoding: .utf8).trimmed()
        return contents
    } catch {
        print("Could not load data from file \(filePath). \(error.localizedDescription).")
        exit(EXIT_FAILURE)
    }
}

runDay03()
