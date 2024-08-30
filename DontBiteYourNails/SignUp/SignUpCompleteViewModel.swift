//
//  SignUpViewModel.swift
//  AImAware
//
//  Created by Suyog on 25/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI

class SignUpCompleteViewModel {
    static let shared = SignUpCompleteViewModel()
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @EnvironmentObject var router: NavigationRouter
    private init(){}
    func addSignUpCompleteData(signUpType: signUpTypeName, signupModel: SignUpCompleteFlowModel, completion: @escaping(_ status: Bool) ->Void){
        
        var model = SignUpCompleteFlowModel()
        model = fetchDataAsLocally()
        model.userComes = signupModel.userComes
        model.userAuthType = signupModel.userAuthType
        
        switch signUpType {
        case .createSignup:
            model.useFullName = signupModel.useFullName
            model.userEmail = signupModel.userEmail
            storeDataAsLocally(model: model, typeName: signUpTypeName.createSignup.rawValue) { status in
                completion(status)
            }
            
        case .stateSignup:
            model.userAge = signupModel.userAge
            model.userHeight = signupModel.userHeight
            model.userGender = signupModel.userGender
            model.userCity = signupModel.userCity
            storeDataAsLocally(model: model, typeName: signUpTypeName.stateSignup.rawValue){ status in
                completion(status)
            }
            
        case .habitSignup:
            model.userHabit = signupModel.userHabit
            storeDataAsLocally(model: model, typeName: signUpTypeName.habitSignup.rawValue){ status in
                completion(status)
            }
            
        case .finishSignup:
            storeDataAsLocally(model: model, typeName: signUpTypeName.finishSignup.rawValue){ status in
                completion(status)
            }
          
        case .subHabitSignup:
            model.userHabit = signupModel.userHabit
            model.userSubHabit = signupModel.userSubHabit
            storeDataAsLocally(model: model, typeName: signUpTypeName.subHabitSignup.rawValue){ status in
                completion(status)
            }
            
        case .reminderSignup:
            model.userReminder = signupModel.userReminder
            model.userWeekendReminder = signupModel.userWeekendReminder
            storeDataAsLocally(model: model, typeName: signUpTypeName.reminderSignup.rawValue){ status in
                completion(status)
            }
            
        case .weekendSignup:
            model.userWeekendReminder = signupModel.userWeekendReminder
            storeDataAsLocally(model: model, typeName: signUpTypeName.weekendSignup.rawValue){ status in
                completion(status)
            }
            
          
        case .completeSignup:
            model.userWeekendReminder = signupModel.userWeekendReminder
            storeDataAsLocally(model: model, typeName: signUpTypeName.finishSignup.rawValue){ status in
                completion(status)
            }
            
        default:
            break
        }
    }
    
    func fetchDataAsLocally() -> SignUpCompleteFlowModel{
        if let data = USER_DEFAULTS.object(forKey: COMPLETESIGNUPDATA) as? Data,
           let customModel = try? JSONDecoder().decode(SignUpCompleteFlowModel.self, from: data) {
            return customModel
        }else{
            return SignUpCompleteFlowModel()
        }
    }
    
    func storeDataAsLocally(model: SignUpCompleteFlowModel, typeName: String, completion: @escaping(_ status: Bool) ->Void){
        if let encoded = try? JSONEncoder().encode(model) {
            
            USER_DEFAULTS.set(encoded, forKey: COMPLETESIGNUPDATA)
            
            if typeName == signUpTypeName.reminderSignup.rawValue {
                DatabaseManager.shared.setUserReminder(userId: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "") { status in
                    if status == 200{
                        USER_DEFAULTS.removeObject(forKey: COMPLETESIGNUPDATA)
                        USER_DEFAULTS.removeObject(forKey: FROMSIGNUP)
                        //self.introProgressTracker.isUserLoggedIn = true
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
                
            }else if typeName == signUpTypeName.habitSignup.rawValue {
                DatabaseManager.shared.setUserDetails(userId: SignUpCompleteViewModel.shared.getCurrentUserId() ?? "") { status in
                    if status == 200{
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }else{
                completion(true)
            }
        }else{
            completion(false)
        }
    }
    
    
    func getCurrentUserId() -> String? {
        let userId = USER_DEFAULTS.object(forKey: USERID)
        return userId as? String ?? ""
    }
    
    func removeAllKeys(){
        USER_DEFAULTS.removeObject(forKey: COMPLETESIGNUPDATA)
        USER_DEFAULTS.removeObject(forKey: FROMSIGNUP)
        USER_DEFAULTS.removeObject(forKey: USERID)
        //introProgressTracker.fromWhereToNavigate = ""
        
    }
    
    func checkDataExistOrNot(completion: @escaping(_ type: String) -> Void){
        DatabaseManager.shared.getUserDetail { userDetail, status in
            if status == 200{
                if let name = userDetail[FireStoreChatConstant.userFullName], let reminder = userDetail[FireStoreChatConstant.userReminderArr]{
                    completion("All Exist")
                }else{
                    completion("Reminder not exist")
                }
            }else{
                completion("Not exist")
            }
        }
    }
}




