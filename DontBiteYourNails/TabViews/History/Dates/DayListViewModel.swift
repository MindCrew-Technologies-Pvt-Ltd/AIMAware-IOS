//
//  DayViewModel.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 11/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI
import Combine
import CoreData


class DayListViewModel: ObservableObject {
    @Published var activeDates: [ActiveDate] = []
    
    private var activeDateUpdateObserver: NSObjectProtocol?
    private var sessionUpdateObserver: NSObjectProtocol?
    private var nudgeUpdateObserver: NSObjectProtocol?

    init() {
        updateActiveDates()
        setupObservers()
    }
    
    deinit {
        if let observer = activeDateUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = sessionUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = nudgeUpdateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func setupObservers() {
        activeDateUpdateObserver = NotificationCenter.default.addObserver(
            forName: .activeDateUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateActiveDates()
        }
        sessionUpdateObserver = NotificationCenter.default.addObserver(
            forName: .sesionUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateActiveDates()
        }
        nudgeUpdateObserver = NotificationCenter.default.addObserver(
            forName: .nudgesUpdated,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateActiveDates()
        }
    }

    private func updateActiveDates() {
        self.activeDates = ActiveDateRepo.shared.getAllActiveDays()
    }
}
