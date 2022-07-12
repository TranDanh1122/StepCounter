//
//  Extension.swift
//  StepCounter
//
//  Created by VN Grand M on 11/07/2022.
//

import Foundation
extension Double {
    func toString(maximumFractionDigits: Int=0) -> String {
        return String(format: "%.\(maximumFractionDigits)f", self)
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
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
//    func timeBetweenTodayAnd(anotherDay: Date) -> Double {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let todayString = formatter.string(from: self)
//        let anotherDayString = formatter.string(from: anotherDay)
//        let today = formatter.date(from: todayString)
//        let anotherDay = formatter.date(from: anotherDayString)
//        return (today - anotherDay) / (60.0 * 60.0 * 24.0)
//    }
}
