//
//  Date+Tidy.swift
//  TidyExtension
//
//  Created by wh on 2024/3/5.
//

import Foundation

public extension TidyExtensionWrapper where Base: DateFormatter {
    
    static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = .td.enUSPOSIX
        return formatter
    }
}

public extension TidyExtensionWrapper where Base == Calendar {
    
    /// Gregorian calendar
    static let gregorian = Calendar(identifier: .gregorian)
    
    /// Gregorian calendar,
    static var gregorianMon: Calendar = {
        var monCalendar = Calendar(identifier: .gregorian)
        monCalendar.firstWeekday = 2
        return monCalendar
    }()
    
    /// Chinese calendar
    static let chinese = Calendar(identifier: .chinese)
}

public extension TidyExtensionWrapper where Base == Locale {
    
    static let enUSPOSIX = Locale(identifier: "en_US_POSIX")
}

public extension TidyExtensionWrapper where Base == Date {
    
    var second: Int {
        Calendar.td.gregorian.dateComponents([.second], from: base).second ?? 0
    }
    
    var minute: Int {
        Calendar.td.gregorian.dateComponents([.minute], from: base).minute ?? 0
    }
    
    var hour: Int {
        Calendar.td.gregorian.dateComponents([.hour], from: base).hour ?? 0
    }
    
    var day: Int {
        Calendar.td.gregorian.dateComponents([.day], from: base).day ?? 0
    }
    
    var month: Int {
        Calendar.td.gregorian.dateComponents([.month], from: base).month ?? 0
    }
    
    var year: Int {
        Calendar.td.gregorian.dateComponents([.year], from: base).year ?? 0
    }
    
    var weekday: Int {
        Calendar.td.gregorian.dateComponents([.weekday], from: base).weekday ?? 0
    }
    
    var dayFirst: Date {
        let dateComponents = Calendar.td.gregorian.dateComponents([.year, .month, .day], from: base)
        return Calendar.td.gregorian.date(from: dateComponents)!
    }
    
    var dayMid: Date {
        var dateComponents = Calendar.td.gregorian.dateComponents([.year, .month, .day], from: base)
        dateComponents.hour = 12
        dateComponents.minute = 0
        dateComponents.second = 0
        return Calendar.td.gregorian.date(from: dateComponents)!
    }
    
    var dayLast: Date {
        var dateComponents = Calendar.td.gregorian.dateComponents([.year, .month, .day], from: base)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        return Calendar.td.gregorian.date(from: dateComponents)!
    }
    
    var monthFirst: Date {
        let dateComponents = Calendar.td.gregorian.dateComponents([.year, .month], from: base)
        return Calendar.td.gregorian.date(from: dateComponents)!
    }
    
    var isToday: Bool {
        Calendar.td.gregorian.isDateInToday(base)
    }
    
    var isYesterday: Bool {
        Calendar.td.gregorian.isDateInYesterday(base)
    }
    
    var isTommorrow: Bool {
        Calendar.td.gregorian.isDateInTomorrow(base)
    }
    
    var previous: Date { addingDay(-1) }
    var next: Date { addingDay(1) }
    
    func addingDay(_ dayCount: Int) -> Date {
        Calendar.td.gregorian.date(byAdding: .day, value: dayCount, to: base)!
    }
    
    func dayCountOf(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2:
            if Date.td.isLeapYear(year) { return 29 }
            return 28
        default: return 0
        }
    }
    
    static func isLeapYear(_ year: Int) -> Bool {
        return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)
    }
    
    var general: String { format("yyyy-MM-dd HH:mm:ss") }
    var ymdHm: String { format("yyyy-MM-dd HH:mm") }
    var ymd: String { format("yyyy-MM-dd") }
    var ym: String { format("yyyy-MM") }
    var md: String { format("MM-dd") }
    var hms: String { format("HH:mm:ss") }
    var hm: String { format("HH:mm") }
    var mdHm: String { format("MM-dd HH:mm") }
    var chineseYm: String { format("yyyy年M月") }
    var chineseYmd: String { format("yyyy年M月d日") }
    var chineseMd: String { format("M月d日") }
    var chineseMdHm: String { format("M月d日 HH:mm") }
    var chineseYmdHm: String { format("yyyy年M月d日 HH:mm") }
    
    func format(_ format: String) -> String {
        return DateFormatter.td.formatter(format).string(from: base)
    }
    
    static func date(_ str: String, format: String) -> Date? {
        return DateFormatter.td.formatter(format).date(from: str)
    }
    
    static func general(_ str: String) -> Date? {
        return date(str, format: "yyyy-MM-dd HH:mm:ss")
    }
    
    func isSameDayAs(_ date: Date) -> Bool {
        return Calendar.td.gregorian.isDate(base, inSameDayAs: date)
    }
    
    func isSameMonthAs(_ date: Date) -> Bool {
        return Calendar.td.gregorian.isDate(base, equalTo: date, toGranularity: .month)
    }
    
    func isSameYearAs(_ date: Date) -> Bool {
        return Calendar.td.gregorian.isDate(base, equalTo: date, toGranularity: .year)
    }
}
