//
//  SessionManager.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 04/09/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI;


class SessionManager {
    static let shared = SessionManager()
    
    weak var hostingController: HostingController?
    
    let notificationService = NotificationService.shared
    let appSessionService = AppSessionService.shared
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleRenewSessionNotification), name: NSNotification.Name("RenewSessionNotification"), object: nil)
    }

    @objc func handleRenewSessionNotification() {
        print("handleRenewSessionNotification")
        renewSession()
    }
    
    func renewSession() { // notice: duplicated code
        if let controller = self.hostingController {
            notificationService.cancelOneHourNotification()
            notificationService.scheduleOneHourNotification()
            appSessionService.renewSesion()
            controller.endSession()
            controller.awake()
            print("Session renewed")
        } else {
            print("Hosting controller missing")
        }
    }
}
