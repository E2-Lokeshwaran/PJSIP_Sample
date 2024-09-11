/*
 * Copyright (C) 2012-2012 Teluu Inc. (http://www.teluu.com)
 * Contributed by Emre Tufekci (github.com/emretufekci)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

//import UIKit
//import PushKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        
//        //Voip handling
//        self.registerForPushNotification()
//        self.voipRegistration()
//        
//        //Create Lib
//        CPPWrapper().createLibWrapper()
//
//        //Listen incoming call via function pointer
//        CPPWrapper().incoming_call_wrapper(incoming_call_swift)
//
//        //Listen incoming call via function pointer
//        CPPWrapper().acc_listener_wrapper(acc_listener_swift)
//
//        CPPWrapper().update_video_wrapper(update_video_swift)
//        
//        // Attempt SIP registration
//        self.attemptSIPRegistration()
//
//        return true
//    }
//    
//    
//    func registerForPushNotification() 
//    {
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            print("Permission granted: \(granted)")
//            
//            guard granted else { return }
//            
//            DispatchQueue.main.async 
//            {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//    
//    func voipRegistration()
//    {
//        let mainQueue = DispatchQueue.main
//        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [PKPushType.voIP]
//    }
//    
//    func attemptSIPRegistration() 
//    {
//        if let credentials = UserDefaults.standard.dictionary(forKey: "SIPCredentials") as? [String: String],
//           let username = credentials["username"],
//           let password = credentials["password"],
//           let ip = credentials["ip"],
//           let port = credentials["port"] 
//        {
//            CPPWrapper().createAccountWrapper(username, password, ip, port)
//            print("Attempting SIP registration with saved credentials")
//        } 
//        else
//        {
//            print("No saved SIP credentials found")
//        }
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//}
//
//extension AppDelegate : PKPushRegistryDelegate {
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) 
//    {
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("================================================================")
//        print("VoIP Push Token: ",deviceToken)
//        print("================================================================")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) 
//    {
//        print("pushRegistry:didInvalidatePushTokenForType:")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) 
//    {
//        print(payload.dictionaryPayload)
//        completion()
//    }
//}

//------- DEV CODE -------

//import UIKit
//import PushKit
//import CallKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CXProviderDelegate {
//    
//    var callProvider: CXProvider?
//    var callController: CXCallController?
//    var callObserver: CXCallObserver?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        // Voip handling
//        self.registerForPushNotification()
//        self.voipRegistration()
//        
//        // Create Library
//        CPPWrapper().createLibWrapper()
//
//        // Listen for incoming calls
//        CPPWrapper().incoming_call_wrapper(incoming_call_swift)
//        CPPWrapper().acc_listener_wrapper(acc_listener_swift)
//        CPPWrapper().update_video_wrapper(update_video_swift)
//        
//        // Attempt SIP registration
//        self.attemptSIPRegistration()
//
//        // Setup CallKit
//        self.setupCallKit()
//
//        // Setup Call Observer
//        self.setupCallObserver()
//
//        return true
//    }
//    
//    func registerForPushNotification() {
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            print("Permission granted: \(granted)")
//            
//            guard granted else { return }
//            
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//        
//    func voipRegistration() {
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
//    }
//    
//    func attemptSIPRegistration() {
//        print("SIP: ----------Starts----------")
//        if let credentials = UserDefaults.standard.dictionary(forKey: "SIPCredentials") as? [String: String],
//           let username = credentials["username"],
//           let password = credentials["password"],
//           let ip = credentials["ip"],
//           let port = credentials["port"] {
//            CPPWrapper().createAccountWrapper(username, password, ip, port)
//            print("SIP: Attempting SIP registration with saved credentials")
//        } else {
//            print("SIP: No saved SIP credentials found")
//        }
//    }
//
//    func setupCallKit() {
//        let providerConfiguration = CXProviderConfiguration()
//        providerConfiguration.supportsVideo = true
//        providerConfiguration.maximumCallGroups = 1
//        providerConfiguration.maximumCallsPerCallGroup = 1
//        
//        callProvider = CXProvider(configuration: providerConfiguration)
//        callProvider?.setDelegate(self, queue: nil)
//        
//        callController = CXCallController()
//    }
//    
//    // Setup call observer to monitor call states
//    func setupCallObserver() {
//        callObserver = CXCallObserver()
//        callObserver?.setDelegate(self, queue: nil)
//    }
//
//    // MARK: - CXProviderDelegate methods
//    func providerDidReset(_ provider: CXProvider) {
//        // Handle provider reset
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        // Handle answering the call
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        // Handle ending the call
//        action.fulfill()
//    }
//
//    // MARK: UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
//}
//
//extension AppDelegate: PKPushRegistryDelegate {
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("================================================================")
//        print("VoIP Push Token: ", deviceToken)
//        print("================================================================")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("pushRegistry:didInvalidatePushTokenForType:")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        
//        self.attemptSIPRegistration()
//        
//        // Handle incoming push payload
//        if type == .voIP {
//            // Extract caller name and UUID
//            let callerName = payload.dictionaryPayload["caller_name"] as? String ?? "Unknown Caller"
//            let callUUID = payload.dictionaryPayload["call_uuid"] as? String ?? UUID().uuidString
//            
//            // Print the actual call UUID
//            print("SIP: Incoming call UUID: \(callUUID)")
//            
//            // Report the incoming call to CallKit
//            let update = CXCallUpdate()
//            update.remoteHandle = CXHandle(type: .generic, value: callerName)
//            update.hasVideo = false
//            
//            if let uuid = UUID(uuidString: callUUID) {
//                self.callProvider?.reportNewIncomingCall(with: uuid, update: update) { error in
//                    if let error = error {
//                        print("Failed to report incoming call: \(error.localizedDescription)")
//                    } else {
//                        print("SIP: Incoming call reported")
//                    }
//                }
//            }
//        }
//
//        print(payload.dictionaryPayload)
//        completion()
//    }
//}
//
//// MARK: - CXCallObserverDelegate to observe call state
//extension AppDelegate: CXCallObserverDelegate {
//    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
//        // Print call state and UUID
//        print("SIP: Call UUID: \(call.uuid)")
//        
//        if call.hasConnected {
//            print("SIP: Call has connected")
//        } else if call.hasEnded {
//            print("SIP: Call has ended")
//        } else if call.isOutgoing {
//            print("SIP: Outgoing call is in progress")
//        } else {
//            print("SIP: Incoming call ringing")
//        }
//    }
//}

//---------------pre final code---------------
//import UIKit
//import PushKit
//import CallKit
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CXProviderDelegate {
//    
//    var callProvider: CXProvider?
//    var callController: CXCallController?
//    var callObserver: CXCallObserver?
//    var unifiedCallUUID: UUID?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        // Voip handling
//        self.registerForPushNotification()
//        self.voipRegistration()
//        
//        // Create Library
//        CPPWrapper().createLibWrapper()
//
//        // Listen for incoming calls
//        CPPWrapper().incoming_call_wrapper(incoming_call_swift)
//        CPPWrapper().acc_listener_wrapper(acc_listener_swift)
//        CPPWrapper().update_video_wrapper(update_video_swift)
//        
//        // Attempt SIP registration
//        self.attemptSIPRegistration()
//
//        // Setup CallKit
//        self.setupCallKit()
//
//        // Setup Call Observer
//        self.setupCallObserver()
//
//        return true
//    }
//    
//    func registerForPushNotification() {
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            print("Permission granted: \(granted)")
//            
//            guard granted else { return }
//            
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//        
//    func voipRegistration() {
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
//    }
//    
//    func attemptSIPRegistration() {
//        print("SIP: ----------Starts----------")
//        if let credentials = UserDefaults.standard.dictionary(forKey: "SIPCredentials") as? [String: String],
//           let username = credentials["username"],
//           let password = credentials["password"],
//           let ip = credentials["ip"],
//           let port = credentials["port"] {
//            CPPWrapper().createAccountWrapper(username, password, ip, port)
//            print("SIP: Attempting SIP registration with saved credentials")
//        } else {
//            print("SIP: No saved SIP credentials found")
//        }
//    }
//
//    func setupCallKit() {
//        let providerConfiguration = CXProviderConfiguration()
//        providerConfiguration.supportsVideo = true
//        providerConfiguration.maximumCallGroups = 1
//        providerConfiguration.maximumCallsPerCallGroup = 1
//        
//        callProvider = CXProvider(configuration: providerConfiguration)
//        callProvider?.setDelegate(self, queue: nil)
//        
//        callController = CXCallController()
//    }
//    
//    // Setup call observer to monitor call states
//    func setupCallObserver() {
//        callObserver = CXCallObserver()
//        callObserver?.setDelegate(self, queue: nil)
//    }
//
//    // MARK: - CXProviderDelegate methods
//    func providerDidReset(_ provider: CXProvider) {
//        // Handle provider reset
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        // Handle answering the call
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        // Handle ending the call
//        action.fulfill()
//    }
//
//    // MARK: UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
//}
//
//extension AppDelegate: PKPushRegistryDelegate {
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("================================================================")
//        print("VoIP Push Token: ", deviceToken)
//        print("================================================================")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("pushRegistry:didInvalidatePushTokenForType:")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        
//        self.attemptSIPRegistration()
//        
//        // Handle incoming push payload
//        if type == .voIP {
//            // Extract caller name and UUID for the actual call
//            let callerName = payload.dictionaryPayload["caller_name"] as? String ?? "Unknown Caller"
//            let callUUID = payload.dictionaryPayload["call_uuid"] as? String ?? UUID().uuidString
//
//            // Handle fake call scenario and merge it
//            self.handleUnifiedCall(callerName: callerName, actualCallUUID: callUUID)
//        }
//
//        print(payload.dictionaryPayload)
//        completion()
//    }
//    
//    func handleUnifiedCall(callerName: String, actualCallUUID: String) {
//        // Merge both actual and fake call data
//        
//        // If a unified call UUID does not exist, create one
//        if unifiedCallUUID == nil {
//            unifiedCallUUID = UUID()
//        }
//        
//        // Print the unified UUID and simulate the call state
//        print("SIP: Unified Call UUID: \(unifiedCallUUID!)")
//        print("SIP: Actual Call UUID: \(actualCallUUID)")
//        
//        // Report the call to CallKit using the unified UUID
//        let update = CXCallUpdate()
//        update.remoteHandle = CXHandle(type: .generic, value: callerName)
//        update.hasVideo = false
//        
//        self.callProvider?.reportNewIncomingCall(with: unifiedCallUUID!, update: update) { error in
//            if let error = error {
//                print("Failed to report unified call: \(error.localizedDescription)")
//            } else {
//                print("SIP: Unified call reported")
//            }
//        }
//    }
//}
//
//// MARK: - CXCallObserverDelegate to observe call state
//extension AppDelegate: CXCallObserverDelegate {
//    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
//        // Print call state and UUID for the unified call
//        guard let unifiedUUID = unifiedCallUUID, call.uuid == unifiedUUID else {
//            return
//        }
//        
//        // Print the unified call UUID and its state
//        print("SIP: Unified Call UUID: \(unifiedUUID)")
//        
//        if call.hasConnected {
//            print("SIP: Unified Call has connected")
//        } else if call.hasEnded {
//            print("SIP: Unified Call has ended")
//        } else if call.isOutgoing {
//            print("SIP: Outgoing Unified call in progress")
//        } else {
//            print("SIP: Incoming Unified call ringing")
//        }
//    }
//}


//----------Final code-------------


import UIKit
import PushKit
import CallKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CXProviderDelegate {
    
    var callProvider: CXProvider?
    var callController: CXCallController?
    var callObserver: CXCallObserver?
    var unifiedCallUUID: UUID?
    
    
    
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // VoIP handling
        self.registerForPushNotification()
        self.voipRegistration()
        
        // Create Library
        CPPWrapper().createLibWrapper()

        // Listen for incoming calls
        CPPWrapper().incoming_call_wrapper(incoming_call_swift)
        CPPWrapper().acc_listener_wrapper(acc_listener_swift)
        CPPWrapper().update_video_wrapper(update_video_swift)
        
        // Attempt SIP registration
        self.attemptSIPRegistration()

        // Setup CallKit
        self.setupCallKit()

        // Setup Call Observer
        self.setupCallObserver()

        return true
    }
    
    func registerForPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
        
    func voipRegistration() {
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    func attemptSIPRegistration() {
        print("SIP: ----------Registration Starts----------")
        if let credentials = UserDefaults.standard.dictionary(forKey: "SIPCredentials") as? [String: String],
           let username = credentials["username"],
           let password = credentials["password"],
           let ip = credentials["ip"],
           let port = credentials["port"] {
            CPPWrapper().createAccountWrapper(username, password, ip, port)
            print("SIP: Attempting SIP registration with saved credentials")
        } else {
            print("SIP: No saved SIP credentials found")
        }
    }

    func setupCallKit() {
        let providerConfiguration = CXProviderConfiguration()
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallGroups = 1
        providerConfiguration.maximumCallsPerCallGroup = 1
        
        callProvider = CXProvider(configuration: providerConfiguration)
        callProvider?.setDelegate(self, queue: nil)
        
        callController = CXCallController()
    }
    
    func setupCallObserver() {
        callObserver = CXCallObserver()
        callObserver?.setDelegate(self, queue: nil)
    }

    // MARK: - CXProviderDelegate methods
    func providerDidReset(_ provider: CXProvider) {
        // Handle provider reset
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Handle answering the call
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Handle ending the call
        action.fulfill()
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("================================================================")
        print("VoIP Push Token: ", deviceToken)
        print("================================================================")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        self.attemptSIPRegistration()
        
        if type == .voIP {
            if let eMessData = payload.dictionaryPayload["eMessData"] as? [String: Any]
            {
                if let wakeProp  =  eMessData["WakeupProperties"] as? [String: String]
                 {
                    print("callerName",wakeProp["CallerName"] ?? "err1")
                    print("CallerExtension",wakeProp["CallerExtension"] ?? "err2")
                    print("UUID",wakeProp["UUID"] ?? "errr3")
                    
                    
                     let callUUIDString = payload.dictionaryPayload["UUID"] as? String ?? UUID().uuidString
                      let callName = wakeProp["CallerName"]
                     let callUUID = UUID(uuidString: callUUIDString) ?? UUID()
                    self.handleUnifiedCall(callerName: callName! , actualCallUUID: callUUID)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                    {
                        self.declineCall(callUUID: callUUID)
                    }
                }
            }
        }
        
        

        print(payload.dictionaryPayload)
        completion()
    }
    
    func declineCall(callUUID: UUID) {
            // Check if there's a valid call associated with the UUID before ending it
        let calls = callController?.callObserver.calls
        if let call = calls!.first(where: { $0.uuid == callUUID }) {
                if call.hasConnected || call.isOutgoing || !call.hasEnded {
                    // Proceed to end the call if it is active
                    let endCallAction = CXEndCallAction(call: callUUID)
                    let transaction = CXTransaction(action: endCallAction)

                    callController?.request(transaction) { error in
                        if let error = error
                        {
                            print("ccc Error ending the call: \(error.localizedDescription)")
                        } 
                        else
                        {
                            print("ccc Call declined successfully")
                        }
                    }
                } 
            else
            {
                    print("ccc Call with UUID \(callUUID) is not active or already ended.")
                }
            } 
        else
        {
                print("ccc No call with UUID \(callUUID) found.")
            }
        }
    
    
    func handleUnifiedCall(callerName: String, actualCallUUID: UUID) {
        // Create or use existing unified call UUID
//        if unifiedCallUUID == nil {
//            unifiedCallUUID = UUID()
//        }

        // Print UUIDs
//        print("SIP: Unified Call UUID: \(unifiedCallUUID!)")
        print("SIP: Actual Call UUID: \(actualCallUUID)")

        // Report the call to CallKit
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: callerName)
        update.hasVideo = false

        callProvider?.reportNewIncomingCall(with: actualCallUUID, update: update) { error in
            if let error = error 
            {
                print("Failed to report unified call: \(error.localizedDescription)")
            } 
            else
            {
                print("SIP: Unified call reported")
            }
        }
    }
}

// MARK: - CXCallObserverDelegate to observe call state
extension AppDelegate: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        guard let unifiedUUID = unifiedCallUUID, call.uuid == unifiedUUID else {
            return
        }

        print("SIP: Unified Call UUID: \(unifiedUUID)")

        if call.hasConnected {
            print("SIP: Unified Call has connected")
        } else if call.hasEnded {
            print("SIP: Unified Call has ended")
        } else if call.isOutgoing {
            print("SIP: Outgoing Unified call in progress")
        } else {
            print("SIP: Incoming Unified call ringing")
        }
    }
}



