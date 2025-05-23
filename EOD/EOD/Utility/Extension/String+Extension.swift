//
//  String+Extension.swift
//  EOD
//
//  Created by USER on 2023/09/09.
//

import Foundation
import UIKit

// MARK:- 기타 Util성

extension String {
    /// SwifterSwift: URL from string (if applicable).
    ///
    ///        "https://google.com".url -> URL(string: "https://google.com")
    ///        "not url".url -> nil
    ///
    var url: URL? {
        return URL(string: self)
    }
    
    /// 스트링에서 HTML Tag를 추출해서 array로 리턴한다.
    public var htmlTags: [String]? {
        guard let regEx = try? NSRegularExpression(pattern: "<a(.|\\n)*?<\\/a>", options: []) else { return nil }
        let matches = regEx.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        
        return matches.map({ (self as NSString).substring(with: $0.range) })
    }
    
    /// String에서 HTML tag를 제거한다.
    public var stripHtmlTag: String {
        guard let regEx = try? NSRegularExpression(pattern: "<(.|\n)*?>", options: []) else { return self }
        
        return regEx.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: count), withTemplate: "")
    }
    
    /// API relative path encoding
    public var apiEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: urlCharacterSet) ?? self
    }
    
    // API parameter encoding
    public var apiParameterEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: urlCharacterSet.subtracting(CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] \n"))) ?? self
    }
    
    /// UTF-8 encode
    public var utf8Encoded: String? {
        guard let messageData = data(using: .nonLossyASCII) else { return nil }
        return String(data: messageData, encoding: .utf8)
    }
    
    private var urlCharacterSet: CharacterSet {
        return CharacterSet.urlFragmentAllowed
            .union(.urlHostAllowed)
            .union(.urlPasswordAllowed)
            .union(.urlQueryAllowed)
            .union(.urlUserAllowed)
    }
    
    /// https://가 붙어있지 않은 스트링이면 http:// 헤더를 붙인다. 이미 붙어있으면 return self
    public var appendUrlHeaderIfNeed: String {
        return isValidUrlHeader ? self : "https://" + self
    }
    
    /// 스트링에 http:// 혹은 https:// 헤더가 붙어있는지 판단한다.
    public var isValidUrlHeader: Bool {
        return hasPrefix("http://") || hasPrefix("https://")
    }
    
    /// white space를 %20 타입 스페이스로 변경한다.
    public var adjustWhiteSpace: String {
        return components(separatedBy: .whitespaces).joined(separator: " ")
    }
    
    public var thumbnailSourceURL: String? {
        guard let decoded = self.removingPercentEncoding else { return nil }
        let components = decoded.split(separator: "\"").compactMap({ String($0) })
        
        return components.count == 3 ? components[1] : nil
    }
    
    public var extractNumber: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    /// url용으로 encoding한 스트링 생성
    public var encoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 스트링에서 공백을 제거한 후 URL instance 생성
    public var spaceRemovedUrl: URL? {
        return URL(string: replacingOccurrences(of: " ", with: ""))
    }
    
    public var numberOfNewLines: Int {
        return unicodeScalars.filter({ NSCharacterSet.newlines.contains($0) }).count
    }
    
    /// 텍스트 길이가 허용 Length보다 초과하였는지 판단하는 메소드.
    /// Length 1당 4Byte로 판단하며.
    /// 이모지는 8Byte로, 한글/영어 등은 4Byte로 일괄 계산한다.
    public func isLengthExceeded(maxLength: Int) -> Bool {
//        return bytesWithEmojiAs8bytes > maxLength * 4
        return count > maxLength * 4 // TODO: 잘못된 로직이기 때문에 나중에 사용할 일 있으면 다시 확인해보기
    }
    
    /// 허용 Length보다 긴 텍스트를 허용 범위에 맞게 뒷부분을 자른 후 리턴하는 메소드
    public func lengthLimited(maxLength: Int) -> String {
        var text = self
        
        while text.isLengthExceeded(maxLength: maxLength) {
            text.removeLast()
        }
        
        return text
    }
    
    /// 글자수 카운팅 (숫자 영문은 1글자, 그 외에는 2글자로 계산. 채널명 편집용)
    public var characterCount: Int {
        charactersArray
            .map { min(2, $0.utf8.count) }
            .sum()
    }
    
    /// 제한 글자수에 맞게 뒷부분을 자른 스트링을 생성한다. (숫자 영문은 1글자, 그 외에는 2글자로 계산. 채널명 편집용)
    public func countLimited(maxCount: Int) -> String {
        var text = self
        while text.characterCount > maxCount {
            text.removeLast()
        }
        return text
    }
}

extension String {
    
    /// 스트링이 비어있는지 (count가 0이거나 공백만 존재하는지) 판단한다.
    public var isBlank: Bool {
        return blankRemoved.count == 0
    }
    
    /// 공백을 제거한 스트링을 리턴한다
    public var blankRemoved: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    /// 텍스트 앞 공백 제거
    public var blankPrefixRemoved: String {
        var target = self
        while target.starts(with: " ") {
            target.removeFirst()
        }
        return target
    }
    
    /// 텍스트 뒤 공백 제거
    public var blankPostfixRemoved: String {
        var target = self
        while target.ends(with: " ") {
            target.removeLast()
        }
        return target
    }
    
    /// 스트링 마지막의 모든 개행문자 제거
    public var removedLastCRs: String {
        if let last = lastCharacterAsString, carriageReturns.contains(last) {
            return String(dropLast()).removedLastCRs
        } else {
            return self
        }
    }
    
    /// 텍스트 앞뒤 공백 제거, 줄바꿈을 공백으로 치환 후 공백 2개 이상을 공백 하나로 치환
    public var replaceReturnAndBlanks: String {
        return blankPrefixRemoved
            .blankPostfixRemoved
            .replacingOccurrences(of: "\n", with: " ")
            .replaceMultipleBlanks
    }
    
    /// 공백 2개 이상을 공백 하나로 치환
    var replaceMultipleBlanks: String {
        var changed: String = self
        while changed.contains("  ") == true {
            changed = changed.replacingOccurrences(of: "  ", with: " ")
        }
        return changed
    }
    
    /// \t 제거
    var tabRemoved: String {
        return replacingOccurrences(of: "\t", with: "")
    }
    
    var carriageReturns: [String] { return ["\n", "\r"] }
    
    /// SwifterSwift: Array of characters of a string.
    var charactersArray: [Character] {
        return Array(self)
    }
}

extension String {
    
    /// 특정 키워드의 NSRange를 찾는다.
    ///
    /// - Parameters:
    ///   - keyword: 검색할 단어
    ///   - caseSensitive: 대소문자 구별 여부. true면 구별, false면 구별안함
    /// - Returns: NSRange array. 단어가 없으면 return nil
    public func findRanges(keyword: String, caseSensitive: Bool = true) -> [NSRange]? {
        let pattern = "(\(caseSensitive ? keyword : keyword.lowercased()))+"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }
        
        let target = caseSensitive ? self : lowercased()
        let result = regex.matches(in: target, range: NSRange(location: 0, length: target.count))
        let ranges = result.compactMap({ $0.range })
        
        return ranges.count > 0 ? ranges : nil
    }
}

extension String {
    
    /// validate color code
    public var isValidColorCode: Bool {
        guard count == 6 else { return false }
        
        return lowercased().rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789abcdef")) != nil
    }
}

extension String {
    
    // 검색 전용 기능. <ta> 태그를 찾아서 단어 앞에 #을 붙여준다.
    public var hashTagAppended: String {
        guard let regex = try? NSRegularExpression(pattern: "(\\w*<ta>)", options: [.caseInsensitive]) else { return self }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count))
        
        var modified = self
        matches.compactMap({ $0.range.location })
            .sorted(by: { $0 > $1 })
            .forEach({ modified.insert("#", at: modified.index(modified.startIndex, offsetBy: $0)) })
        
        return modified
    }
}

// MARK:- Hash Tag

public extension String {
    
    /// 수정 전 본문의 해시태그 갯수가 제한 해시태그보다 많을 경우 뒤쪽 해시태그를 삭제
    func filter(fromMaxHashTagCount count: Int) -> String {
        let totalHashTagCount = hashTagsRange.count
        guard totalHashTagCount > count else { return self }
        
        let willRemovedHashTagCount = totalHashTagCount - count
        var newText = self
        
        hashTagsRange.reversed()[0..<willRemovedHashTagCount].forEach({
            newText = (newText as NSString).replacingCharacters(in: $0, with: "")
        })
        
        return newText
    }
    
    // 해쉬태그 패턴 FE와 맞춘 것.
    var hashTagPattern: String { return RegexParser.hashtagPattern }
    
    var hashTagRegex: NSRegularExpression? {
        return try? NSRegularExpression(pattern: hashTagPattern, options: [])
    }
    
    /// 단순히 해시태그 갯수만 알면 될 때, hashTags.count 보다는 이것을 사용하기를 권장.
    var hashTagCount: Int {
        return hashTagRegex?.numberOfMatches(in: self, options: [], range: self.fullRange) ?? 0
    }
    
    var hashTagsRange: [NSRange] {
        guard let textCheckingResult = hashTagRegex?.matches(in: self, options: [], range: self.fullRange) else {
            return []
        }
        
        return textCheckingResult.compactMap({ $0.range })
    }
    
    /// 추출 과정이 복잡하기 때문에, 해시태그가 꼭 String으로 필요할 때만 사용할 것.
    var hashTags: [String] {
        return hashTagsRange.compactMap({ (self as NSString).substring(with: $0) })
    }
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: (self as NSString).length)
    }
}

// MARK: - Date

public extension String {
    /// 한국 서버에서 내려준 시간대를 한국 타임존 기준의 Date instance로 변환한다.
    /// yyyy-MM-dd 형식
    var summaryDateInKoreaTimeZone: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.seoul
        dateFormatter.dateFormat = "yyyy-MM-dd" // 날짜 형식에 맞춰 설정
        return dateFormatter.date(from: self) // self는 변환하고자 하는 날짜 문자열
    }
    
    /// 한국 서버에서 내려준 시간대를 한국 타임존 기준의 Date instance로 변환한다.
    /// yyyy-MM-dd'T'HH:mm:ss.SSSZ 형식
    var dateInKoreaTimeZone: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.seoul
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 날짜 형식에 맞춰 설정
        return dateFormatter.date(from: self) // self는 변환하고자 하는 날짜 문자열
    }
    
    /// 2020-04-07T10:20:00 / 2020-04-07T10:20:00.000 포맷의 스트링을 Date로 변환한다.
    var presetDate: Date? {
        return ["yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss.SSS"].compactMap({ $0.dateFormatter.date(from: self) }).first
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = self
        
        return formatter
    }
}
