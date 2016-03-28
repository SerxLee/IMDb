//
//  StringExtension.swift
//  IMDb
//
//  Created by Serx on 16/3/28.
//  Copyright © 2016年 serx. All rights reserved.
//


import Foundation

extension String{
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func contains(s: String) -> Bool{
        return (self.rangeOfString(s) != nil) ? true : false
    }
    
    func replace(target: String, withString: String) -> String{
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> Character{
        get {
            let index = self.startIndex.advancedBy(i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String{
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func subString(startIndex: Int, length: Int) -> String{
        
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    func indexOf(target: String) -> Int{
        let range = self.rangeOfString(target)
        if let range = range {
            
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int{
        
        let startRange = self.startIndex.advancedBy(startIndex)
        
        let range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int{
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool{
        let exp:AnyObject?
        
        do{
        
            exp = try! NSRegularExpression(pattern: regex,
                options: options)
            
            return exp!.firstMatchInString(self, options:[],
                range: NSMakeRange(0, utf16.count)) != nil
        }
    }
    
    func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]{
        
        do{
            
           let exp = try! NSRegularExpression(pattern: regex,
                options: options)
            
            let matches = exp.matchesInString(self, options: [], range: NSMakeRange(0, self.length))
            
            return matches as [NSTextCheckingResult]
        }
    }
    
    private var vowels: [String]{
        get{
            return ["a", "e", "i", "o", "u"]
        }
    }
    
    private var consonants: [String]{
        
        get{
            return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
        }
    }
    
    func pluralize(count: Int) -> String{
        if count == 1 {
            return self
        } else {
            let lastChar = self.subString(self.length - 1, length: 1)
            let secondToLastChar = self.subString(self.length - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercaseString == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                prefix = self[0...self.length - 1]
                suffix = "ies"
            } else if lastChar.lowercaseString == "s" || (lastChar.lowercaseString == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                prefix = self[0...self.length]
                suffix = "es"
            } else {
                prefix = self[0...self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercaseString ? suffix : suffix.uppercaseString)
        }
    }
    
    func findIndexOf(letter: String)->Int?{
        
        let tempString = self
        var selfArray:[String] = []
        
        var index = 0
        
        for character in tempString.characters{
            
            selfArray.append(String(character))
        }
        
        for _ in 0..<selfArray.count{
            if letter == selfArray[index]{
                return index
            }
            
            ++index
        }
        return nil
    }
}