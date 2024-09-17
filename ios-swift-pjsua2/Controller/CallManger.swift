//
//  CallManger.swift
//  ios-swift-pjsua2
//
//  Created by Lokeshwaran on 17/09/24.
//

import Foundation
import CallKit
import UIKit

var theCallManager: CallManager?

class CallManager: NSObject
{
    static let shared = CallManager()
    var callController = CXCallController()
    //private(set) var provider: CXProvider?
    let provider: CXProvider


    override init() {
        provider = CXProvider(configuration: CXProviderConfiguration())
        callController = CXCallController()
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    @objc static func instance() -> CallManager {
        if (theCallManager == nil) {
            theCallManager = CallManager()
        }
        return theCallManager!
    }
    
    
    func updateCall(uuid: UUID, handle: String, hasVideo: Bool = false) 
    {
        print("SIP: CallKit: UpdateCall: UUID: [\(uuid.description)] From: [\(handle)]")
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type:.generic, value:handle)
        update.localizedCallerName = handle
        update.hasVideo = hasVideo
        provider.reportCall(with:uuid, updated:update);
    }
    
    //for 7 sec delay
//    func endCallNotExist(uuid: UUID, timeout: DispatchTime) {
//        DispatchQueue.main.asyncAfter(deadline: timeout) {
//            
//            if let myDelegate = UIApplication.shared.delegate as? AppDelegate
//            {
//                let callId = myDelegate.callInfos[uuid]?.callId
//                let call =  CallManager.instance().lc?.currentCall
//                if (call == nil) {
//                    print("SIP: CallKit: terminate call with call-id: \(String(describing: callId)) and UUID: \(uuid) which does not exist.")
//
//                    CallManager.instance().providerDelegate.endCall(uuid: uuid)
//                    removeAllCallInfos()
//            }
//
//            }
//        }
//    }
    
    
    func removeAllCallInfos() {
        
        if let myDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            print("SIP: CallKit: removeAllCallInfos called, these infos will be removed: \(myDelegate.callInfos)")

            myDelegate.callInfos.removeAll()
            myDelegate.uuids.removeAll()
        }
       
   }
}
