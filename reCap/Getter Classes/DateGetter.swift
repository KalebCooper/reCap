//
//  DateGetter.swift
//  reCap
//
//  Created by Jackson Delametter on 3/5/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import Foundation

class DateGetter {
    
    private static let DATE_STYLE = DateFormatter.Style.medium
    private static let TIME_STYLE = DateFormatter.Style.short
    
    class func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DATE_STYLE
        dateFormatter.timeStyle = TIME_STYLE
        return dateFormatter.string(from: date)
    }
    
    class func getDateFromString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DATE_STYLE
        dateFormatter.timeStyle = TIME_STYLE
        return dateFormatter.date(from: string)!
    }
}
