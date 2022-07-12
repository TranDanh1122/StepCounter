//
//  Extension.swift
//  StepCounter
//
//  Created by VN Grand M on 11/07/2022.
//

import Foundation
import CoreMotion
extension Double {
    func toString(maximumFractionDigits: Int=0) -> String {
        return String(format: "%.\(maximumFractionDigits)f", self)
    }
    func toInt() -> Int {
        return Int(self)
    }
}
extension Date {

    var startOfThisDate: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfThisDate)!
    }
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
    func timeBetweenTodayAnd(anotherDay: Date) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let todayString = formatter.string(from: self)
        let anotherDayString = formatter.string(from: anotherDay)
        if let today = formatter.date(from: todayString),let anotherDay = formatter.date(from: anotherDayString) {
            return (today.endOfDay - anotherDay.startOfThisDate) / (60 * 60 * 24)
        }
       return 0
    }
}
extension CMPedometerData {
    var distanceUnW: NSNumber {
        guard let distanceUnW = self.distance else { return 0 }
       return distanceUnW
    }
    var mile: String {
        return ("\(String(format: "%.1f",(distanceUnW.doubleValue / 1000))) mil")
    }
    var time: String {
        if let pace = self.averageActivePace, pace.doubleValue != 0 {
           return ("\((distanceUnW.doubleValue * pace.doubleValue / 60).toString()) m")
        } else {
            return "_:_"
        }
    }
    var calories: String {
        return ("\((distanceUnW.doubleValue * 70.0 / 1000 * 0.95 ).toString()) kcal")
    }
    var stokeEnd: Double {
        return self.numberOfSteps.doubleValue / 10000
    }
}
