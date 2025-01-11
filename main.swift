//
//  main.swift
//  Advent of Code 2015
//
//  Created by Ivan Welsh on 24/12/2024.
//

import Foundation
import CryptoKit

extension String {
    func trimmed() -> String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
    
    func md5() -> String {
        if let data = self.data(using: .utf8) {
            let hash = Insecure.MD5.hash(data: data)
            return hash.map { String(format: "%02hhx", $0) }.joined()
        }
        return ""
    }
    
    func md5Raw() -> Insecure.MD5Digest {
        return Insecure.MD5.hash(data: self.data(using: .utf8)!)
    }
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

extension Dictionary {
    mutating func getValueOrConstruct(forKey key: Key, defaultValue: Value) -> Value {
        if let existingValue = self[key] {
            return existingValue
        } else {
            self[key] = defaultValue
            return defaultValue
        }
    }
}

extension Collection {
    var isNotEmpty: Bool {
        get { !self.isEmpty }
    }
}

func loadData(from filename: String) -> String {
    let filePath = "data/\(filename)"
    do {
        let contents = try String(contentsOfFile: filePath, encoding: .utf8).trimmed()
        return contents
    } catch {
        print("Could not load data from file \(filePath). \(error.localizedDescription).")
        exit(EXIT_FAILURE)
    }
}

runDay13()


