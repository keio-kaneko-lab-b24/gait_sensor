import SwiftUI
import CoreData
import Foundation


/*
 https://stackoverflow.com/questions/43663622/is-a-date-in-same-week-month-year-of-another-date-in-swift
 */
extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) && isEqual(to: date, toGranularity: .year) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) && isEqual(to: date, toGranularity: .year) }
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date) &&
        isEqual(to: date, toGranularity: .month) &&
        isEqual(to: date, toGranularity: .year)
    }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}

/*
 unixtime（ミリ秒）を取得する
 */
func unixtime() -> Int {
    return Int(NSDate().timeIntervalSince1970 * 1000)
}

/*
 unixtime（ミリ秒）からDateへ変換する
 */
func unixtimeToDate(unixtimeMillis: Int) -> Date {
    let unixtime = Int(unixtimeMillis / 1000)
    return NSDate(timeIntervalSince1970: TimeInterval(unixtime)) as Date
}

/*
 unixtime（ミリ秒）から「xxxx年xx月xx日（x） xx:xx:xx」表記に変換する
 */
func unixtimeToDateString(unixtimeMillis: Int, short: Bool = false, mini: Bool = false) -> String {
    let unixtime = Int(unixtimeMillis / 1000)
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixtime))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    
    if (mini) {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date as Date)
        return String(dateString.suffix(5))
    }
    
    // 日付
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    let dateString = dateFormatter.string(from: date as Date)
    // 時間
    dateFormatter.dateStyle = .none
    if (short) {
        dateFormatter.timeStyle = .short
    } else {
        dateFormatter.timeStyle = .medium
    }
    let timeString = dateFormatter.string(from: date as Date)
    
    // 曜日
    let weekday = Calendar.current.component(.weekday, from: date as Date)
    let weekdayString = dateFormatter.shortWeekdaySymbols[weekday - 1]
    return "\(dateString)(\(weekdayString)) \(timeString)"
}

/*
 現在時刻をyyyyMMddHHmmssで取得する
 */
func currentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    return dateFormatter.string(from: Date())
}

/*
 time（秒）からDateStringへ変換する
 */
func timeToString(time: Int) -> String {
    let minutes = Int(floor(Double(time)/60))
    let seconds = Int(Double(time).truncatingRemainder(dividingBy: 60.0))
    var minutesString: String
    var secondsString: String
    if minutes < 10 {
        minutesString = String("0\(minutes)")
    } else {
        minutesString = String("\(minutes)")
    }
    if seconds < 10 {
        secondsString = String("0\(seconds)")
    } else {
        secondsString = String("\(seconds)")
    }
    return String("\(minutesString):\(secondsString)")
}

/*
 過去N日前（N週間前、N月前）まの日付をDayStruct型として取得する
 */
func lastDates(n: Int, unit: Calendar.Component) -> [DateStruct] {
    let anchor = Date()
    let calendar = Calendar.current
    var dates = [DateStruct]()
    
    if unit == .day {
        for dayOffset in 0...n {
            if let date = calendar.date(byAdding: .day, value: -1*dayOffset, to: anchor) {
                dates.append(DateStruct(date: date))
            }
        }
    }
    
    if unit == .weekOfYear {
        for dayOffset in 0...n {
            if let date = calendar.date(byAdding: .day, value: -7*dayOffset, to: anchor) {
                dates.append(DateStruct(date: date))
            }
        }
    }
    
    if unit == .month {
        for dayOffset in 0...n {
            if let date = calendar.date(byAdding: .month, value: -1*dayOffset, to: anchor) {
                dates.append(DateStruct(date: date))
            }
        }
    }
    
    return dates
}

struct DateStruct: Identifiable {
    var date: Date
    var id = UUID()
}
