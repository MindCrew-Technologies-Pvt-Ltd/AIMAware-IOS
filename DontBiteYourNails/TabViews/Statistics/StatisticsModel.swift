//
//  StatsModel.swift
//  AImAware
//
//  Created by Suyog on 30/05/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


struct statsConfirmedIgnoredModel {
    var confirmIgnoreCount : Int?
    init(confirmIgnoreCount: Int? = nil) {
        self.confirmIgnoreCount = confirmIgnoreCount
    }
}

struct statsUserStatusModel {
    var userStatusCount : Int?
    var userStatusName : String?
    init(userStatusCount: Int? = nil, userStatusName: String? = nil) {
        self.userStatusCount = userStatusCount
        self.userStatusName = userStatusName
    }
}

struct statsMonthModel {
    var monthStr : String?
    init(monthStr: String? = nil) {
        self.monthStr = monthStr
    }
}

struct statsAllTypeModel {
    var status: String?
    var feeling: String?
    var situation: String?
    var urgeIntensity: Int?
    var day: String?
    var dateMonth: String?
    
    init(status: String? = nil, feeling: String? = nil, situation: String? = nil, urgeIntensity: Int? = nil, day: String? = nil, dateMonth: String? = nil) {
        self.status = status
        self.feeling = feeling
        self.situation = situation
        self.urgeIntensity = urgeIntensity
        self.day = day
        self.dateMonth = dateMonth
    }
}

class statsGetDataStatus {
    var confirmedIgnoredWeek: Int?
    var confirmedIgnoredMonth: Int?
    var feelingWeek: Int?
    var feelingMonth: Int?
    var workScheduleToday: Int?
    var workScheduleWeek: Int?
    var workScheduleMonth: Int?
    var averageIntensityToday: Int?
    var averageIntensityWeek: Int?
    var averageIntensityMonth: Int?
    
    init(confirmedIgnoredWeek: Int? = nil, confirmedIgnoredMonth: Int? = nil, feelingWeek: Int? = nil, feelingMonth: Int? = nil, workScheduleToday: Int? = nil, workScheduleWeek: Int? = nil, workScheduleMonth: Int? = nil, averageIntensityToday: Int? = nil, averageIntensityWeek: Int? = nil, averageIntensityMonth: Int? = nil) {
        self.confirmedIgnoredWeek = confirmedIgnoredWeek
        self.confirmedIgnoredMonth = confirmedIgnoredMonth
        self.feelingWeek = feelingWeek
        self.feelingMonth = feelingMonth
        self.workScheduleToday = workScheduleToday
        self.workScheduleWeek = workScheduleWeek
        self.workScheduleMonth = workScheduleMonth
        self.averageIntensityToday = averageIntensityToday
        self.averageIntensityWeek = averageIntensityWeek
        self.averageIntensityMonth = averageIntensityMonth
    }
}
