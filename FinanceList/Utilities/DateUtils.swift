//
//  DateUtils.swift
//  FinanceList
//
//  Created by Byron Hundley on 8/13/21.
//

import Foundation

class DateUtils {
    // Example
    // "date": "2020-11-10T08:10:12.001Z"
    public class var iso8601DateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }

    public class var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
    
    public class func formattedDateString(_ isoDateString: String) -> String? {
        if let date = iso8601DateFormatter.date(from: isoDateString) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
