//
//  SwiftyRegex.swift
//  SwiftyRegex
//
//  Created by Chris on 18/07/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

class SwiftyRegex {
    let regex: NSRegularExpression
    
    init?(pattern: String) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        self.regex = regex
    }
    
    public func matches(string: String) -> Bool {
        let fullRange = NSRange(location: 0, length: string.utf16.count)
        
        return regex.firstMatch(in: string, options: [], range: fullRange) != nil
    }
    
    public func matches(string: String) -> [Match] {
        let fullRange = NSRange(location: 0, length: string.utf16.count)
        
        let matches = regex.matches(in: string, options: [], range: fullRange)
        
        return matches.map { match in
            let wholeRange = match.range(at: 0)
            let wholeMatch = (string as NSString).substring(with: wholeRange)
            
            let groups = (1..<match.numberOfRanges).map { idx -> String in
                let groupRange = match.range(at: idx)
                return (string as NSString).substring(with: groupRange)
            }
            
            return Match(wholeMatch: wholeMatch, groups: groups)
        }
    }
    
    public struct Match {
        let wholeMatch: String
        let groups: [String]
    }
}
