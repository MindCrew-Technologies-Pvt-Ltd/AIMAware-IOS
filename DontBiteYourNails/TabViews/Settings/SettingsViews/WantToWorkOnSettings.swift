//
//  WantToWorkOnSettings.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


class WantsToWorkOnSettings: ObservableObject {
    static let shared = WantToWorkOnSettings()
    
    @Published var wantsToWorkOnHairPulling: Bool = UserDefaults.standard.bool(forKey: SharedConstants.)
    @Published var wantsToWorkOnSkinPicking: Bool = UserDefaults.standard.bool(forKey: SharedConstants.)
    @Published var wantsToWorkOnNailBiting: Bool = UserDefaults.standard.bool(forKey: SharedConstants.)
    @Published var wantsToWorkOnNosePicking: Bool = UserDefaults.standard.bool(forKey: SharedConstants.)
    @Published var wantsToWorkOnOther: Bool = UserDefaults.standard.bool(forKey: SharedConstants.)
}
