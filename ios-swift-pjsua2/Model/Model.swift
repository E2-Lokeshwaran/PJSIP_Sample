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
import CallKit


func topMostController() -> UIViewController {
    var topController: UIViewController = (UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController!)!
    while (topController.presentedViewController != nil) {
        topController = topController.presentedViewController!
    }
    return topController
}

//func incoming_call_swift() {
//    print("-----Incoming call started")
//    DispatchQueue.main.async () {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
//        let topVC = topMostController()
//        let vcToPresent = vc.storyboard!.instantiateViewController(withIdentifier: "incomingCallVC") as! IncomingViewController
//        vcToPresent.incomingCallId = CPPWrapper().incomingCallInfoWrapper()
//        topVC.present(vcToPresent, animated: true, completion: nil)
//    }
//}



var callName = "123"



//var calltestuuid = getuuid

func incoming_call_swift() {
    print("-----Incoming call started--------")
    print("SIP: callIdString initial start",CPPWrapper().incomingCallInfoWrapper()!)
    DispatchQueue.main.async ()
    {
        let state: UIApplication.State = UIApplication.shared.applicationState
        let callIdString = CPPWrapper().incomingCallInfoWrapper() ?? "Unknown"
        print("SIP: callIdString ",CPPWrapper().incomingCallInfoWrapper()!)
        let callInfo = CallInfo.newIncomingCallInfo(callId: callIdString)
        
        let callerName = "Unknown"
        let callName = "Unknown"
        
        if state != .active
        {
            print("SIP: CallKit: Presenting call kit for BG mode")
            print("SIP: Call kit: Actual Caller Name: \(callerName)")
            print("SIP: Call Kit: Call ID: \(callInfo.callId)")
            
            if let myDelegate = UIApplication.shared.delegate as? AppDelegate
            {
                //myDelegate.handleCall(callerName: callName , actualCallUUID: callUUID)
               //to create actual call here
                //myDelegate.displayIncomingCall(handle: callName, hasVideo: false, callId: callInfo.callId, callerName: callerName, callUUID: callUUID)
                
                let callId = CPPWrapper().incomingCallInfoWrapper()
                print("SIP: Callkit: Call ID on BG ",callId!)
                let extensions = extractExtension(from: callId ?? "")
                print("SIP: Callkit: Extension on BG ",extensions)
            
                if let uuid = myDelegate.uuids["\(extensions)"] {
                    print("SIP: Callkit: uuid for dummy call ",uuid)
                    
                        print("SIP: CallKIt: Call merging started")
                        CallManager.instance().updateCall(uuid: uuid , handle: callName )
                        if let callInfo = myDelegate.callInfos[uuid]
                        {
                            print("SIP: CallKIt: Callinfos ",callInfo)
                            myDelegate.reportIncomingCall(uuid: uuid , handle: callName, hasVideo: false)

                        }
                        
                    else
                    
                    {
                        
                    }
                }


            }
        }
        
        else 
        {
            
            DispatchQueue.main.async () {
                print("SIP: Presenting call kit for FG mode")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
                let topVC = topMostController()
                let vcToPresent = vc.storyboard!.instantiateViewController(withIdentifier: "incomingCallVC") as! IncomingViewController
                print("SIP: callIdString FG ",CPPWrapper().incomingCallInfoWrapper()!)
                vcToPresent.incomingCallId = CPPWrapper().incomingCallInfoWrapper()
                topVC.present(vcToPresent, animated: true, completion: nil)
            }
        }
    }
}


func extractExtension(from callId: String) -> String {
    // Assuming the format is something like "sip:1234@example.com"
    // or "1234@example.com" or just "1234"
    let components = callId.components(separatedBy: "@")
    let firstPart = components.first ?? ""
    let extensionPart = firstPart.components(separatedBy: ":").last ?? ""
    return extensionPart
}

func call_status_listener_swift ( call_answer_code: Int32)
{
    print("SIP: Call State Code ", call_answer_code)
    
    if (call_answer_code == 0)
    {
        DispatchQueue.main.async ()
        {
            UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    } 
    else if (call_answer_code == 1)
    {
        DispatchQueue.main.async ()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
            let vcToPresent = vc.storyboard!.instantiateViewController(withIdentifier: "activeCallVC") as! ActiveViewController
            if (vcToPresent.presentedViewController != nil) 
            {
                let topVC = topMostController()
                vcToPresent.activeCallId = CPPWrapper().incomingCallInfoWrapper()
                topVC.present(vcToPresent, animated: true, completion: nil)
            }
        }
    }
}

//func call_status_listener_swift(call_answer_code: Int32) {
//    if call_answer_code == 0 {
//        DispatchQueue.main.async {
//            UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController?.dismiss(animated: true, completion: nil)
//        }
//    } else if call_answer_code == 1 {
//        DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let topVC = topMostController()
//            let vcToPresent = storyboard.instantiateViewController(withIdentifier: "activeCallVC") as! ActiveViewController
//            if topVC.presentedViewController != nil {
//                vcToPresent.activeCallId = CPPWrapper().incomingCallInfoWrapper()
//                topVC.present(vcToPresent, animated: true, completion: nil)
//            }
//        }
//    }
//}

func update_video_swift(window: UnsafeMutableRawPointer?)
{
    DispatchQueue.main.async () 
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
        let activeVc = vc.storyboard!.instantiateViewController(withIdentifier: "activeCallVC") as! ActiveViewController
        let topVC = topMostController()
        activeVc.activeCallId = CPPWrapper().incomingCallInfoWrapper()
        topVC.present(activeVc, animated: true, completion: nil)
        let vid_view:UIView =
            Unmanaged<UIView>.fromOpaque(window!).takeUnretainedValue();
        activeVc.loadViewIfNeeded()
        activeVc.updateVideo(vid_win: vid_view);
    }
}




 
