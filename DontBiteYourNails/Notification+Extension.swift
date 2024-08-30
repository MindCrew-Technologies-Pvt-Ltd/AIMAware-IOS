//
//  Notification+Extension.swift
//  AImAware
//
//  Created by Sune on 18/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let nudgesUpdated = Notification.Name("nudgesUpdatedNotification")
    static let sesionUpdated = Notification.Name("sessionUpdatedNotification")
    static let activeDateUpdated = Notification.Name("activeDateUpdatedNotification")
    static let settingRecordUpdated = Notification.Name("settingRecordUpdatedNotification")
    static let settingWatchRecordUpdated = Notification.Name("settingWatchRecordUpdatedNotification")
}
