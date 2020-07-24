//
//  SwiftyRegex.swift
//  SwiftyRegex
//
//  Created by Chris on 18/07/2020.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation

public class Regex {
    let regex: NSRegularExpression
    
    public init?(pattern: String) {
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
        
        return matches.map { Match(string: string, match: $0) }
    }

    public struct Match {
        private let string: String
        private let match: NSTextCheckingResult

        public let wholeMatch: String
        public let groups: [String]

        init(string: String, match: NSTextCheckingResult) {
            self.string = string
            self.match = match
            let wholeRange = match.range(at: 0)
            wholeMatch = (string as NSString).substring(with: wholeRange)

            groups = (1..<match.numberOfRanges).map { idx -> String in
                let groupRange = match.range(at: idx)
                return (string as NSString).substring(with: groupRange)
            }
        }
        
        @available(macOS 10.13, *)
        public func group(named name: String) -> String? {
            let namedRange = match.range(withName: name)
            guard namedRange.location != NSNotFound else { return nil }
            return (string as NSString).substring(with: namedRange)
        }
    }
}
