//
//  Date+Extension.swift
//  EOD
//
//  Created by JooYoung Kim on 10/3/24.
//

import Foundation

extension Date {
    
    /// 디바이스 언어에 맞는 포맷의 날짜 스트링
    ///
    /// ~ 59초 : 방금 전
    /// 1분 ~ 59분 : N분전
    /// 1시간 ~ 23시 59분 : N시간 전
    /// 24시간 ~ : 년월일
//    public var timeStamp: String {
//        let intervalInSec = Date().timeIntervalSince(self)
//        
//        switch intervalInSec {
//        case ..<60: return Localization.justMoment
//            
//        case ..<3_600:
//            let minutes = min(59, max(1, (intervalInSec / 60.0).rounded(.down).int))
//            return String(format: (minutes == 1 ? Localization.dateMinuteAgo : Localization.dateMinutesAgo), minutes.string)
//            
//        case ..<(60 * 60 * 24):
//            let hours = min(23, max(1, (intervalInSec / 3600.0).rounded(.down).int))
//            return String(format: (hours == 1 ? Localization.dateHourAgo : Localization.dateHoursAgo), hours.string)
//            
//        default: return "\(year)년 \(month)월 \(day)일"
//        }
//    }
    
    public var yearMonthDay: String {
        return "\(year)년 \(month)월 \(day)일"
    }
    
//    public var yearMonthDayHourMinute: String {
//        return "\(year.shortYear)년 \(month.zeroPrefixed)월 \(day.zeroPrefixed)일 \(hour.zeroPrefixed):\(minute.zeroPrefixed)"
//    }
    
    public var dotSeparated: String {
        return "\(year).\(month < 10 ? "0\(month)" : "\(month)").\(day < 10 ? "0\(day)" : "\(day)")"
    }
    
    // 유효기간 vaildDay를 지났는지?
    public func wasExpired(validDay: Int) -> Bool {
        let diffSecond = (Date().timeIntervalSinceNow - self.timeIntervalSinceNow)
        
        return diffSecond > 60 * 60 * 24 * Double(validDay)
    }
    
    /// API Parameter용 yyyy-MM-dd 포맷의 스트링으로 변환
    public var apiParameter: String {
        return "\(year)-\(month.zeroPrefixed)-\(day.zeroPrefixed)"
    }
    
    /// 서울 타임존을 적용한 yyyy-MM-dd'T'HH:mm:ss 포맷의 스트링으로 변환
    public var apiParameterInKoreaTimeZone: String {
        string(withFormat: "yyyy-MM-dd'T'HH:mm:ss", timeZone: TimeZone.seoul)
    }
    
    /// Date를 foramt에 맞게 String으로 변환, 이 때 TimeZone을 설정할 수 있다. `TimeZone.seoul` 을 사용하면 서울 시간으로 적용됨.
    public func string(withFormat format: String = "dd/MM/yyyy HH:mm", timeZone: TimeZone?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}

extension String {
    public func isoDate(from GMT: Int = 9) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        formatter.timeZone = TimeZone(secondsFromGMT: GMT)
        return formatter.date(from: self)
    }
}

extension TimeZone {
    /// 서울 시간대
    public static var seoul: TimeZone? {
        TimeZone(identifier: "Asia/Seoul")
    }
}
