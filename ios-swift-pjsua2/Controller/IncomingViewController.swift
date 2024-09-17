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
import PushKit

var actualCallUUID = UUID()



class IncomingViewController: UIViewController,CXProviderDelegate
{

    var currentCallUUID: UUID?
    var incomingCallId : String = ""
    @IBOutlet weak var callTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Incoming Call"
        
        // Extract and print only the extension
        let extensions = extractExtension(from: incomingCallId)
        
        callTitle.text = extensions
        print("SIP: Extension",extensions)
        
        CallManager.shared.provider.setDelegate(self, queue: nil)
        // Report incoming call to CallKit
        reportIncomingCall()
        CPPWrapper().call_listener_wrapper(call_status_listener_swift)
    }
    
    func extractExtension(from callId: String) -> String {
        // Assuming the format is something like "sip:1234@example.com"
        // or "1234@example.com" or just "1234"
        let components = callId.components(separatedBy: "@")
        let firstPart = components.first ?? ""
        let extensionPart = firstPart.components(separatedBy: ":").last ?? ""
        return extensionPart
    }
    
    func reportIncomingCall() {
         let update = CXCallUpdate()
         update.remoteHandle = CXHandle(type: .phoneNumber, value: incomingCallId)
         update.hasVideo = false
        currentCallUUID = UUID()
        guard let callUUID = currentCallUUID else 
        {
             print("SIP: Error: No UUID available for reporting incoming call")
             return
         }
        actualCallUUID = currentCallUUID ?? UUID()
        print("SIP end: Received incoming call : ", currentCallUUID ?? "000")
        
        
        
         
        CallManager.shared.provider.reportNewIncomingCall(with: UUID(), update: update) { error in
             if let error = error {
                 print("SIP: Failed to report incoming call reportIncomingCall() : \(error.localizedDescription)")
             }
         }
     }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        CPPWrapper().hangupCall();
    }
    
    
    @IBAction func hangupClick(_ sender: UIButton) {
        guard let callUUID = currentCallUUID else {
                    print("SIP: Error: No current call UUID available")
                    return
                }
                
                CPPWrapper().hangupCall()
                self.dismiss(animated: true, completion: nil)
                
                let endCallAction = CXEndCallAction(call: callUUID)
                let transaction = CXTransaction(action: endCallAction)
        
                print("SIP end: Requesting EndCallAction with UUID: \(callUUID)")
                
        CallManager.shared.callController.request(transaction) { error in
                    if let error = error {
                        print("SIP: EndCallAction transaction request failed hangupClick(): \(error.localizedDescription)")
                    } else {
                        print("SIP: EndCallAction transaction request succeeded")
                    }
                }
            }
    
    
    @IBAction func answerClick(_ sender: UIButton) {
        guard let callUUID = currentCallUUID else {
            print("SIP: Error: No current call UUID available")
            return
        }
        
        CPPWrapper().answerCall()
        
        let answerCallAction = CXAnswerCallAction(call: callUUID)
        let transaction = CXTransaction(action: answerCallAction)
        
        print("SIP: Requesting AnswerCallAction with UUID: \(callUUID)")
        
        CallManager.shared.callController.request(transaction) { error in
            if let error = error {
                print("SIP: AnswerCallAction transaction request failed answerClick(): \(error.localizedDescription)")
            } else {
                print("SIP: AnswerCallAction transaction request succeeded")
            }
        }
    }
    
    // CXProviderDelegate methods
    func providerDidReset(_ provider: CXProvider) 
    {
        // Handle provider reset
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        CPPWrapper().answerCall()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        CPPWrapper().hangupCall()
        action.fulfill()
    }
    
    // Call status listener
//    func call_status_listener_swift(_ status: Int32) {
//           DispatchQueue.main.async {
//               switch status {
//               case 0: // Call ended
//                   guard let callUUID = self.currentCallUUID else { return }
//                   CallManager.shared.provider.reportCall(with: callUUID, endedAt: Date(), reason: .remoteEnded)
//               case 1: // Call connected
//                   guard let callUUID = self.currentCallUUID else { return }
//                   CallManager.shared.provider.reportOutgoingCall(with: callUUID, startedConnectingAt: Date())
//               case 2: // Call disconnected
//                   guard let callUUID = self.currentCallUUID else { return }
//                   CallManager.shared.provider.reportCall(with: callUUID, endedAt: Date(), reason: .failed)
//               default:
//                   break
//               }
//           }
//       }
   }

extension CallManager: CXProviderDelegate {
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
}
