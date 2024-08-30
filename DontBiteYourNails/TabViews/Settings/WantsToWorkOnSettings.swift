//
//  WantToWorkOnSettings.swift
//  AImAware
//
//  Created by Sune on 17/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation


class WantsToWorkOnSettings: ObservableObject {
    static let shared = WantsToWorkOnSettings()
    
    @Published var wantsToWorkOnHairPulling: Bool = UserDefaults.standard.bool(forKey: SharedConstants.wantsToWorkOnHairPulling)
    @Published var wantsToWorkOnSkinPicking: Bool = UserDefaults.standard.bool(forKey: SharedConstants.wantsToWorkOnSkinPicking)
    @Published var wantsToWorkOnNailBiting: Bool = UserDefaults.standard.bool(forKey: SharedConstants.wantsToWorkOnNailBiting)
    @Published var wantsToWorkOnNosePicking: Bool = UserDefaults.standard.bool(forKey: SharedConstants.wantsToWorkOnNosePicking)
    @Published var wantsToWorkOnOther: Bool = UserDefaults.standard.bool(forKey: SharedConstants.wantsToWorkOnOther)
    @Published var wantsToWorkOnOtherStringAnswer: String = (UserDefaults.standard.string(forKey: SharedConstants.wantsToWorkOnOtherStringAnswer) ?? "")
}
