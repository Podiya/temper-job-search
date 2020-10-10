//
//  DateExtension.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 10/10/20.
//

import Foundation

extension Date {
    var nextThreeDates: [Date] {
        var dates = [Date]()
        for i in 1...3 {
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: self) else { return dates }
            dates.append(date)
        }
        return dates
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
