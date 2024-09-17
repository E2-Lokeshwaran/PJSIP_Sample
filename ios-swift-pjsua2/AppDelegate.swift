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

import UIKit
import PushKit
import CallKit

@objc class CallInfo: NSObject {
    var callId: String = ""
    var accepted = false
    //var toAddr: Address?
    var isOutgoing = false
    var sasEnabled = false
    var declined = false
    var connected = false
    
    static let shared = CallManager()
    
    static func newIncomingCallInfo(callId: String) -> CallInfo {
        let callInfo = CallInfo()
        callInfo.callId = callId
        return callInfo
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CXProviderDelegate {
    
    var uuids: [String : UUID] = [:]
    var callInfos: [UUID : CallInfo] = [:]
    var window: UIWindow?
    var callProvider: CXProvider?
    var callController: CXCallController?
    var callObserver: CXCallObserver?
    var unifiedCallUUID: UUID?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // VoIP handling
        //self.registerForPushNotification()
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
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallGroups = 1
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        
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
        CPPWrapper().answerCall()
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Handle ending the call
        CPPWrapper().hangupCall()
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
            print("SIP: voip push called")
            if let eMessData = payload.dictionaryPayload["eMessData"] as? [String: Any]
            {
                if let wakeProp  =  eMessData["WakeupProperties"] as? [String: String]
                 {
                    print("callerName",wakeProp["CallerName"] ?? "err1")
                    print("CallerExtension",wakeProp["CallerExtension"] ?? "err2")
                    print("UUID",wakeProp["UUID"] ?? "errr3")
                    
                    
                    let callUUIDString = wakeProp["UUID"] ?? UUID().uuidString
                    let callName = wakeProp["CallerName"]
                    let callUUID = UUID(uuidString: callUUIDString) ?? UUID()
                    if let callExt = wakeProp["CallerExtension"] {
                        uuids.updateValue(callUUID, forKey: callExt)
                        print("SIP: Callkit: Incoming Voip push received and recognized with callID: \(callUUID)")
                        
                        displayIncomingCall(handle: callExt, hasVideo: false, callId: callExt,callerName: callName!, callUUID: callUUID)
                    }
                                       
                }
            }
        }
        print(payload.dictionaryPayload)
        completion()
    }
    
    func displayIncomingCall(handle: String, hasVideo: Bool, callId: String, callerName: String, callUUID: UUID) {
        let callInfo = CallInfo.newIncomingCallInfo(callId: callId)
        callInfos[callUUID] = callInfo
        print("SIP: callInfo ",callInfo)
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: callerName)
        update.hasVideo = hasVideo

        callProvider?.reportNewIncomingCall(with: callUUID, update: update) { error in
            if let error = error 
            {
                print("Failed to report incoming call: \(error.localizedDescription)")
            } 
            else
            {
                print("Incoming call reported to CallKit")
            }
            
            //Call delay 
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0)
//            {
//                print("SIP: Setting Delay")
//                CPPWrapper().unregisterAccountWrapper()
//            }
            
        }
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
    
    
    func handleCall(callerName: String, actualCallUUID: UUID) {
        print("getuuid SIP: Actual Call UUID: \(actualCallUUID)")

        // Report the call to CallKit
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: callerName)
        update.hasVideo = false

        callProvider?.reportNewIncomingCall(with: actualCallUUID, update: update) { error in
            if let error = error 
            {
                print("Failed to report Incoming call: \(error.localizedDescription)")
            }
            else
            {
                print("Handle Incoming call reported to CallKit")
            }
        }
    }
    
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool) {
        
        
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type:.generic, value: handle)
        update.hasVideo = hasVideo
        update.supportsDTMF = false
        update.supportsHolding = false
        update.supportsGrouping = false
        update.supportsUngrouping = false
        update.hasVideo = false
        update.localizedCallerName = handle
        
        let callInfo = callInfos[uuid]
        let callerExt = callInfo?.callId
        
        print("SIP: CallKit: Report new incoming call with call-id: [\(String(describing: callerExt))] and UUID: [\(uuid.description)]")
        

        
    
        CallManager.shared.provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil
            {
                print("SIP: CallKit: Timeout for Dummy incoming call to merge with actual call is 7 seconds, starts now")
                //CallManager.instance().providerDelegate.endCallNotExist(uuid: uuid, timeout: .now() + 7)
            }
            else
            {
                print("SIP: CallKit: Cannot complete incoming call with call-id: [\(String(describing: callerExt))] and UUID: [\(uuid.description)] from [\(handle)] caused by [\(error!.localizedDescription)]")
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



