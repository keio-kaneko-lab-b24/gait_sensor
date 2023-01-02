import Foundation

func unixtime() -> Int {
    return Int(NSDate().timeIntervalSince1970)
}
