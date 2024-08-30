//
//  Date+Extension.swift
//  AImAware
//
//  Created by Suyog on 16/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

// Simple extension if you have to create multiple of the same object
extension DateComponents {
    static func triggerFor(hour: Int, minute: Int, weekday: Int) -> DateComponents {
      var component = DateComponents()
      component.calendar = Calendar.current
      component.hour = hour
      component.minute = minute
      component.weekday = weekday
      return component
   }
}

extension TimeInterval {
    func convertTimeIntervalToString() -> String {
        let aDate = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: aDate)
        return time
    }
}

