import SwiftUI
import CoreData
import Foundation


func unixtime() -> Int {
    return Int(NSDate().timeIntervalSince1970)
}

func unixtimeToDate(unixtime: Int) -> Date {
    return NSDate(timeIntervalSince1970: TimeInterval(unixtime)) as Date
}

/*
 unixtimeから「xxxx年xx月xx日（x） xx:xx:xx」表記に変換する
 */
func unixtimeToDateString(unixtime: Int, short: Bool = false) -> String {
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixtime))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ja_JP")
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
