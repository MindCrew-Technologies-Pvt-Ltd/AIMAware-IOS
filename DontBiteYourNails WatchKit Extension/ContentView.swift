//
//  ContentView.swift
//  DontBiteYourNails WatchKit Extension
//
//  Created by Sune Kristian Jakobsen on 24/03/2020.
//  Copyright © 2020 Sune Kristian Jakobsen. All rights reserved.
//
import SwiftUI
import CoreMotion
import Foundation
import WatchKit
import UserNotifications
struct ContentView: View {
    
    let controller: HostingController
    let notificationService = NotificationService.shared
    let watchPhoneConnector = WatchPhoneConnector.shared
    let recordSessionService = RecordSessionService.shared
    let sessionManager = SessionManager.shared
    let config = Config.shared
    
    @StateObject var activateAlertService = ActivateAlertService()
    @StateObject var appSessionService = AppSessionService.shared
    @ObservedObject private var settings = WatchSettings.shared
    @State private var isShowQuestions = false
    @State private var alreadyStarted = false
    @State private var isRunningHandBound = false
    @State private var headingAtRaise = 0.0
    @State private var headingChange = 0.0
    @State private var headingChangeGood = false
    @State private var watchPlacement = WatchPlacement(crownLocation: 1.0, wristLocation: 1.0)
    @State private var timeRunning = 0.0
    @State private var normalisedMotionData : NormalisedMotionData?
    //@State private var startWallClockTime: Date?
    
    @State private var timeString = "00:00:00"
    
    @State private var startTime: Date?
    
    @State private var minutesExpiration = 0
    @State private var secondsExpiration = 0
    @State private var timeRemaining = "00:00"
    
    @State private var showingMotionDataAlert = false
    
    @State private var isShowingAlertOnDelay = false
    
    
    fileprivate func playRenew() {
        if(!self.isRunning()) {
            self.play()
        } else {
            print("renewwwwwwwww")
            self.renewSession()
        }
    }
    
    fileprivate func play() {
        //print("playedddddddddddddddd")
        sessionManager.hostingController = controller
        self.setOrientation()
        notificationService.cancelOneHourNotification()
        notificationService.scheduleOneHourNotification()
        appSessionService.sessionAction(action: .start, isLeftHand: self.watchPlacement.wristLocation < 0)
        self.startTime = Date()
        self.controller.awake()
    }
    
    fileprivate func pause() {
        //print("pauseeeeeeeeeeeeeeee")
        notificationService.cancelOneHourNotification()
        recordSessionService.flush()// if we are not recording there will be nothing to flush
        appSessionService.sessionAction(action: .end, isLeftHand: self.watchPlacement.wristLocation < 0)
        self.controller.endSession()
        self.startTime = nil
    }
    
    fileprivate func renewSession() {
        print("renewSessionnnnnnnnnnn")
        notificationService.cancelOneHourNotification()
        notificationService.scheduleOneHourNotification()
        appSessionService.sessionAction(action: .renew, isLeftHand: self.watchPlacement.wristLocation < 0)
        self.controller.endSession()
        self.controller.awake()
    }
    
    
    fileprivate func reset() {
       // print("resettttttttttttttttttt")
        activateAlertService.resetNumberOfAlerts()
        if(self.isRunning()) {
            self.pause()
        }
        self.setOrientation()
        self.timeRunning = 0.0
        self.startTime = Date()
        self.timeString = "00:00:00"
        self.minutesExpiration = 0
        self.secondsExpiration = 0
        self.timeRemaining = "00:00"
        
    }
    
    
    fileprivate func prodView() -> some View {
        return VStack(alignment: .leading){
            
            Text(self.timeString).font(.title)
            
            Text("Alert count: \(activateAlertService.getNumberOfAlerts())").font(.headline)
            
            HStack{
                Button(action: {
                    self.playRenew()
                }){
                    Image(systemName: self.isRunningHandBound ? "arrow.clockwise.circle" : "play.circle")
                }
                .conditionalRecordButtonStyle(settings.recordFullSession)
                
                Button(action: {
                    self.reset()
                }){
                    Image(systemName: "stop.circle")
                }
                
            }
            
            Text("Sleeps in: \(self.timeRemaining)").font(.subheadline)
            /*
             HStack{
             Text("Alerts on:")
             //.frame(width: 180, alignment: .leading)
             Spacer()
             Toggle("", isOn: $settings.alertsOn).disabled(true)
             }
             HStack{
             Text("Secondary alerts on:")
             //.frame(width: 180, alignment: .leading)
             Spacer()
             Toggle("", isOn: $settings.includeSecondaryAlert).disabled(true)
             }*/
            
            
        }.onAppear(perform: start)
        
            .alert(isPresented: $showingMotionDataAlert) {
                Alert(title: Text("Error"),
                      message: Text("Device motion is not available. This could be due to settings or to the watch."),
                      dismissButton: .default(Text("Got it!")))
            }
        
    }
    
    var body: some View {
        if activateAlertService.activeAlert?.nextQuestion != nil {
            VStack(alignment: .leading) {
                if settings.isShowingBipAndViewAfterDelay {
                    AlertView(resetHostingController: renewSession).environmentObject(activateAlertService)
                }
            }
            
        } else {
            if (!config.showDebugViewOnWatch) {//prod?
                prodView()
                    .onAppear{
                        print(settings.reminderNotification)
                        
                        
                        /*let content = UNMutableNotificationContent()
                        content.title = "AlmAware Watch App"
                        content.body = "Watch app reminder comes"

                        // Create the request
                        //let uuidString = UUID().uuidString
                        let addTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.triggerFor(hour: 23, minute: 30, weekday: 4), repeats: true)
                        let request = UNNotificationRequest(identifier: "stringWatchIdentifier",content: content, trigger: addTrigger)

                        // Schedule the request with the system.
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.add(request) { (error) in
                            print("trigger request \(request)")
                           if error != nil {
                               
                              // Handle any errors.
                           }
                        }*/
                        
                        /*let content = UNMutableNotificationContent()
                        content.title = "AlmAware Watch App"
                        content.body = "Watch app reminder comes"

                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
                        // Create the request
                        let uuidString = UUID().uuidString
                        let request = UNNotificationRequest(identifier: uuidString,content: content, trigger: trigger)

                        // Schedule the request with the system.
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.add(request) { (error) in
                            print("trigger request \(request)")
                           if error != nil {
                               
                              // Handle any errors.
                           }
                        }*/
                        
                        
                        /*let decoded  = USER_DEFAULTS.object(forKey: SharedConstants.reminderNotificationKey) as! Data
                        settings.reminderNotification = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [UNNotificationTrigger] ?? [UNNotificationTrigger]()
                        print(settings.reminderNotification)*/
                        
                        
                    
                        
                        
                            
                        /*CustomNotification.shared.callNotificationForWatch(triggerArr: settings.reminderNotification as? [UNNotificationTrigger] ?? [UNNotificationTrigger]())*/
                    }
            } else {
                ScrollView {
                    prodView()
                    debugView()
                }
            }
        }
    }
    
    fileprivate func debugView() -> some View {
        return VStack{
            Text(config.version)
            
            Text("\(settings.userHeight)")
            
            Text("\(settings.safeUserHeight)")
        }//.onAppear(perform: start)
        /* HStack {
         Text("Alarm")
         Spacer()
         Toggle("", isOn: $settings.alertsOn)
         .labelsHidden()
         }*/
        
        //Text(version)
        /*            Text("aX \(self.normalisedMotionData?.accelX ?? -1)")
         Text("aY \(self.normalisedMotionData?.accelY ?? -1)")
         Text("aZ \(self.normalisedMotionData?.accelZ ?? -1)")
         //Text("head \(self.normalisedMotionData?.heading ?? -1)")
         //Text("yaw \(self.normalisedMotionData?.attitudeYaw ?? -1)")
         //Text("roll \(self.normalisedMotionData?.attitudeRoll ?? -1)")
         Text("crown \(self.normalisedMotionData?.watchPlacement.crownLocation ?? 0)")
         Text("wrist \(self.normalisedMotionData?.watchPlacement.wristLocation ?? 0)")
         
         //     Text("X: \(self.gx)").foregroundColor(self.xGood ? .white : .red)
         //   Text("Y: \(self.gy)").foregroundColor(self.yGood ? .white : .red)
         // Text("Z: \(self.gz)").foregroundColor(self.zGood ? .white : .red)
         //         Text("H: \(self.headingChange)").foregroundColor(self.headingChangeGood ? .white : .red)
         //    Text(self.timeString)
         HStack{
         Button(action: {
         self.playRenew()
         }){
         Image(systemName: self.isRunning() ? "pause.circle" : "play.circle")
         }
         
         Button(action: {
         self.reset()
         
         }){
         Image(systemName: "stop.circle")
         }
         
         }*/
        
    }
    
    
    func isRunning() -> Bool {
        self.isRunningHandBound = (  controller.runtimeSession.state == WKExtendedRuntimeSessionState.running)
        return self.isRunningHandBound
    }
    
    
    fileprivate func movementLoopSimple() {
        // Get the attitude relative to the magnetic north reference frame.
        //                                self.pitch = data.attitude.pitch
        //                                self.roll = data.attitude.roll
        
        //                                self.yaw = data.attitude.yaw
        
        //print("movementLoopSimple")
        //print("before settings.alertsOn \(settings.alertsOn)")
        if (settings.alertsOn) {
            //print("after settings.alertsOn")
            activateAlertService.mlAlert(normalisedMotionData: self.normalisedMotionData)
        }
        //print("end settings.alertsOn")
        if (settings.recordFullSession) {
            recordSessionService.recordMovement(currentNormalisedMotionData: self.normalisedMotionData)
        }
    }
    
    fileprivate func setCurrentValues(_ data: CMDeviceMotion) {
        // Get the attitude relative to the magnetic north reference frame.
        //                                self.pitch = data.attitude.pitch
        //                                self.roll = data.attitude.roll
        
        //                                self.yaw = data.attitude.yaw
        
        
        self.normalisedMotionData = NormalisedMotionData(motionData: data, headingAtRaise: self.headingAtRaise, watchPlacement: self.watchPlacement//, deviceTimestampReference: self.startWallClockTime
        )
        
        if (abs(normalisedMotionData?.gX ?? 0) < 0.2)  {
            self.headingAtRaise = data.heading
        }
        self.headingChange = headingDifference(a: data.heading,
                                               b: self.headingAtRaise)
        
        let timeRunning = -(self.startTime?.timeIntervalSinceNow ?? 0)
        let hours = Int(timeRunning) / 3600
        let minutes = Int(timeRunning) / 60 % 60
        let seconds = Int(timeRunning) % 60
        self.timeString = "\(makeTwoDigit(a: hours)):\(makeTwoDigit(a: minutes)):\(makeTwoDigit(a: seconds))"
        
        
        if let expirationDate = self.controller.runtimeSession.expirationDate {
            let timeRemaining = expirationDate.timeIntervalSince(Date())
            
            if timeRemaining > 3599 {
                self.minutesExpiration = 59
                self.secondsExpiration = 59
            } else {
                self.minutesExpiration = Int(timeRemaining) / 60
                self.secondsExpiration = Int(timeRemaining) % 60
            }
            
        }
        
        self.timeRemaining = "\(makeTwoDigit(a: self.minutesExpiration)):\(makeTwoDigit(a: self.secondsExpiration))"
        
    }
    
    func makeTwoDigit(a: Int) -> String {
        if(a < 10) {
            return "0\(a)"
        } else {
            return "\(a)"
        }
    }
    
    func setOrientation() {
        let interfaceDevice = WKInterfaceDevice()
        let wristLocation : Double
        let crownLocation : Double
        if( WKInterfaceDeviceWristLocation.right == interfaceDevice.wristLocation) {
            wristLocation = 1.0
        } else {
            wristLocation = -1.0
        }
        if( WKInterfaceDeviceCrownOrientation.right == interfaceDevice.crownOrientation) {
            crownLocation = 1.0
        } else {
            crownLocation = -1.0
        }
        self.watchPlacement = WatchPlacement(crownLocation: crownLocation, wristLocation: wristLocation)
    }
    
    func start() {
        if (alreadyStarted) {
            return
        }
        self.alreadyStarted = true
        
        watchPhoneConnector.awake()
        setOrientation()
        let motion = CMMotionManager() // could this be defined at the top of the class
    
        guard motion.isDeviceMotionAvailable else {
            self.showingMotionDataAlert = true
            print("Device motion is not available.")
            return
        }
        
        motion.deviceMotionUpdateInterval = 1.0 / config.updateFrequency
        motion.showsDeviceMovementDisplay = true
        
        //DispatchQueue.main.asyncAfter(deadline: ()) {// inserting delay in case we need to sync with other devices
        //if (settings.useML) {
        motion.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        //} else {
        //    motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        //}
        // original: xMagneticNorthZVertical. Also worth considering: xArbitraryZVertical //xArbitraryCorrectedZVertical <- for use in ML
        //startWallClockTime = Date()
        //print("starteddddddddd>>>>>>>>>>>>>")
        let timer = Timer(fire: nextExecutionDispatch(), interval: (1.0 / config.updateFrequency), repeats: true,
                          block: { (timer) in
            //print("motion.accelerometerData \(motion.accelerometerData)")
            if let data = motion.deviceMotion {
                //print("before started>>>>>>>>>>>>>")
                if(self.isRunning()) {
                    self.timeRunning += 1/config.updateFrequency
                    self.setCurrentValues(data)
                    //print("after started>>>>>>>>>>>>>")
                    self.movementLoopSimple()
                }
            }
        })
        
        // Add the timer to the current run loop.
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        //}
        
    }
    
    func nextExecutionDispatch() -> Date {
        if (!settings.developerSettings) {
            return Date()
        } else {
            let currentTime = Date().timeIntervalSinceReferenceDate
            
            let numberOfPeriods = currentTime * config.updateFrequency
            var nextExecutionTime = (floor(numberOfPeriods) + 0.85)/config.updateFrequency
            if (nextExecutionTime < currentTime) {
                nextExecutionTime = nextExecutionTime + 1.0/config.updateFrequency
            }
            print("nextExecutionTime: \(nextExecutionTime)")
            return Date(timeIntervalSinceReferenceDate: nextExecutionTime)
            //let delay = nextExecutionTime - currentTime
            //return .now() + delay
        }
    }
    
    
    func headingDifference(a: Double, b: Double) -> Double {
        let change = self.watchPlacement.getHeadingMultiplier() * (a - b)
        if( change >= 0) {
            return change
        } else {
            return change + 360
        }
    }
}

extension Button where Label == Image {
    @ViewBuilder
    func conditionalRecordButtonStyle(_ condition: Bool) -> some View {
        if condition {
            self.buttonStyle(.borderedProminent)
                .tint(.red)
        } else {
            self // return unmodified
        }
    }
}
