//
//  PrivacySettings.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation

class PrivacySettings: ObservableObject {
    static let shared = PrivacySettings()
    
    @Published var privacyMetadata: Bool = UserDefaults.standard.bool(forKey: SharedConstants.privacyMetadata)
    @Published var privacyMovementData: Bool = UserDefaults.standard.bool(forKey: SharedConstants.privacyMovementData)
    @Published var privacyUseEmail: Bool = UserDefaults.standard.bool(forKey: SharedConstants.privacyUseEmail)
    
}


