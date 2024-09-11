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

class CallManager: NSObject 
{
    static let shared = CallManager()
    let callController = CXCallController()
    private(set) var provider: CXProvider?
    
    private override init() {
        super.init()
        let providerConfiguration = CXProviderConfiguration()
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        provider = CXProvider(configuration: providerConfiguration)
    }
}

class IncomingViewController: UIViewController,CXProviderDelegate
{

    var incomingCallId : String = ""
    @IBOutlet weak var callTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Incoming Call"
        
        // Extract and print only the extension
        let extensions = extractExtension(from: incomingCallId)
        print("Extension:", extensions)
        
        callTitle.text = extensions
        print("inc",extensions)
        
        CallManager.shared.provider?.setDelegate(self, queue: nil)
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
        print("Received incoming call")
         
         CallManager.shared.provider?.reportNewIncomingCall(with: UUID(), update: update) { error in
             if let error = error {
                 print("SIP: Failed to report incoming call reportIncomingCall() : \(error.localizedDescription)")
             }
         }
     }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        CPPWrapper().hangupCall();
    }
    
    
    @IBAction func hangupClick(_ sender: UIButton) {
        CPPWrapper().hangupCall();
        self.dismiss(animated: true, completion: nil)
        
        let endCallAction = CXEndCallAction(call: UUID())
         let transaction = CXTransaction(action: endCallAction)
         
         CallManager.shared.callController.request(transaction) { error in
             if let error = error {
                 print("SIP: EndCallAction transaction request failed hangupClick() : \(error.localizedDescription)")
             } else {
                 self.dismiss(animated: true, completion: nil)
             }
         }
    }
    
    
    @IBAction func answerClick(_ sender: UIButton) {
        CPPWrapper().answerCall();
        
        let answerCallAction = CXAnswerCallAction(call: UUID())
        let transaction = CXTransaction(action: answerCallAction)
        
        CallManager.shared.callController.request(transaction) { error in
            if let error = error {
                print("SIP: AnswerCallAction transaction request failed answerClick() : \(error.localizedDescription)")
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
//                   CallManager.shared.provider?.reportCall(with: UUID(), endedAt: Date(), reason: .remoteEnded)
//               case 1: // Call connected
//                   CallManager.shared.provider?.reportOutgoingCall(with: UUID(), startedConnectingAt: Date())
//               case 2: // Call disconnected
//                   CallManager.shared.provider?.reportCall(with: UUID(), endedAt: Date(), reason: .failed)
//               default:
//                   break
//               }
//           }
//       }
   }
