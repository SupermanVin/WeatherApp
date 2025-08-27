//  Date+Extensions.swift
//  WeatherNow
//  Created by Vino_Swify on 27/08/25.

import Foundation

extension Date {
    /// Converts Date to a short format like "Aug 27"
    func shortFormat() -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM d"
        return df.string(from: self)
    }

    /// Returns the weekday name (e.g., "Monday")
    var weekdayName: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        return df.string(from: self)
    }
}
