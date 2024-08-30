//
//  PermissionForHealthKitData.swift
//  AImAware
//
//  Created by Sune on 22/11/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import SwiftUI
//import HealthKit

struct GetUserHeightAgeGender: View {
    let settings = PhoneSettings.shared
    
    let advanceIntro: () -> Void
//    let healthStore = HKHealthStore()
    
    var body: some View {
        SingleIntroductionSlideView(
            title: "Here we should ask for height, gender and age, but this is not yet done.",
            explanation: "",
            content: {EmptyView()
                /*Button(action: advanceIntro) {
                Text("Log in (not yet implemented, you just go to next view)")
                }*/
            },
            advanceIntro: {
                advanceIntro()
            })
    }
    
    /*
    func requestHealthKitPermissionThen(completion: @escaping () -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            // HealthKit is not available on this device
            return
        }

        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let typesToRead: Set<HKObjectType> = [heightType]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                DispatchQueue.global(qos: .userInitiated).async {
                    queryHealthKitData()
                }
            }
            completion()
        }
    }
    
    func queryHealthKitData() {
        guard let heightType = HKObjectType.quantityType(forIdentifier: .height) else {
            return
        }

        let query = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, samples, error) in
            guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample else {
                // Handle the case where there's no data or an error
                return
            }

            let heightInMeters = mostRecentSample.quantity.doubleValue(for: HKUnit.meter())
            // Save the height data here
            DispatchQueue.main.async {
                self.saveHeightData(heightInMeters)
            }
        }

        healthStore.execute(query)
    }

    func saveHeightData(_ height: Double) {
        settings.userHeight = height
        
        // Implement the logic to save the height data
        // This could be saving to UserDefaults, CoreData, etc.
    }*/
}
