//
//  Session+Extensions.swift
//  AImAware
//
//  Created by Sune on 07/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

extension Session {
    var primaryAlerts: [Alert]? {
        return (alerts as? Set<Alert>)?.filter { !$0.secondary }
    }

    
    var secondaryAlerts: [Alert]? {
        return (alerts as? Set<Alert>)?.filter { $0.secondary }
    }
}
