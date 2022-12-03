//
//  POC.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/11/30.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Combine
import Shifu
import SwiftUI
import MultipeerConnectivity

class PeerToPeerTunnel: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate{
    @Published var connectedPeers: [MCPeerID] = []
    private(set) var sendingData = PassthroughSubject<(from: MCPeerID , content: Data), Never>()
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true,  session)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        self.connectedPeers = session.connectedPeers
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        sendingData.send((peerID, data))
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        clg(#function)
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        clg(#function)
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        clg(#function)
        
    }
    
    
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        clg(#function)
    }
    
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        clg(#function)
    }
    
    var id:MCPeerID
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    var session: MCSession!
    let serviceType:String
    private(set) var isHosting = false
    
    var displayName: String {
        get {
            id.displayName
        }
        set{
            guard  id.displayName != newValue else { return }
            guard !newValue.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            let hosting = isHosting
            if hosting {
                stopHosting()
            }
            id = MCPeerID(displayName: newValue)
            session = MCSession(peer: id, securityIdentity: nil, encryptionPreference: .none)
            session.delegate = self
            if hosting {
                startHosting()
            }
        }
    }
    
    init(_ name:String? = nil, serviceType: String = "shifu"){
        let name = name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ? UIDevice.current.name : name
        id = MCPeerID(displayName: name ??  UIDevice.current.name)
        session = MCSession(peer: id, securityIdentity: nil, encryptionPreference: .none)
        self.serviceType = serviceType
        super.init()
        session.delegate = self
    }
    func startHosting(){
        guard !isHosting else { return }
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: id, discoveryInfo: nil, serviceType: serviceType)
        mcNearbyServiceAdvertiser.delegate = self
        mcNearbyServiceAdvertiser.startAdvertisingPeer()
        isHosting = true
    }
    
    func stopHosting(){
        if let mcNearbyServiceAdvertiser {
            mcNearbyServiceAdvertiser.stopAdvertisingPeer()
        }
        isHosting = false
    }
    
    func send(_ data: Data) {
        do{
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }catch{
            clg(error)
        }
    }
    
    var connectionSelectingView: some View {
        return PeerBrowser(name: serviceType, session: session)
    }
}

struct PeerBrowser: UIViewControllerRepresentable{
    var name: String
    var session: MCSession
    func makeUIViewController(context: Context) -> MCBrowserViewController {
        let mcBrowser = MCBrowserViewController(serviceType: name, session: session)
        mcBrowser.delegate = context.coordinator
        return mcBrowser
    }
    
    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    typealias UIViewControllerType = MCBrowserViewController
    
    class Coordinator: NSObject,MCBrowserViewControllerDelegate{
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
        }
        
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
        }
    }
    
}
