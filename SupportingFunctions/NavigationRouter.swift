//
//  NavigationRouter.swift
//  AImAware
//
//  Created by Suyog on 20/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

@available(iOS 16.0, *)
final class NavigationRouter: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case tutorialView
        case forgotView
        case loginView
        case signUpView
        case stateView
        case habitView
        case stepToFollowView
        case finishView
        case reminderView
        case weekendView
        case completeView
        
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }

    func navigateToBackCount(lastCount: Int) {
        navPath.removeLast(lastCount)
    }
}


final class NavigationHomeRouter: ObservableObject {
    
    public enum HomeDestination: Codable, Hashable {
        case settingView
        case reminderView
        case weekendView
        
    }
    
    @Published var navHomePath = NavigationPath()
    
    func navigate(to destination: HomeDestination) {
        navHomePath.append(destination)
    }
    
    func navigateBack() {
        navHomePath.removeLast()
    }
    
    func navigateToRoot() {
        navHomePath.removeLast(navHomePath.count)
    }

    func navigateToBackCount(lastCount: Int) {
        navHomePath.removeLast(lastCount)
    }
}


