import SwiftUI

func periodSum(gaits: [Gait], date: Date, item: Item, unit: Calendar.Component) -> Double {
    return gaits.filter {
        let gait_date = unixtimeToDate(unixtimeMillis: Int($0.start_unixtime))
        if unit == .day { return date.isInSameDay(as: gait_date) }
        else if unit == .weekOfYear { return date.isInSameWeek(as: gait_date) }
        else if unit == .month { return date.isInSameMonth(as: gait_date) }
        else { return date.isInSameDay(as: gait_date) }
    }.map {
        if (item == .steps) { return Double($0.gait_steps) }
        else if (item == .energy) { return Double($0.gait_energy) }
        else { return 0 }
    }.max() ?? 0
}

func periodMax(gaits: [Gait], date: Date, item: Item, unit: Calendar.Component) -> Double {
    return gaits.filter {
        let gait_date = unixtimeToDate(unixtimeMillis: Int($0.start_unixtime))
        if unit == .day { return date.isInSameDay(as: gait_date) }
        else if unit == .weekOfYear { return date.isInSameWeek(as: gait_date) }
        else if unit == .month { return date.isInSameMonth(as: gait_date) }
        else { return date.isInSameDay(as: gait_date) }
    }.map {
        if (item == .speed) { return Double($0.gait_speed) * 60 }
        else if (item == .stride) { return Double($0.gait_stride) }
        else if (item == .pace) {
            return 60 * Double($0.gait_steps) / ((Double($0.gait_period) / 1000))
        }
        else { return 0 }
    }.max() ?? 0
}

enum Item: Int {
    case steps = 1
    case energy = 2
    case speed = 3
    case stride = 4
    case pace = 5
}

