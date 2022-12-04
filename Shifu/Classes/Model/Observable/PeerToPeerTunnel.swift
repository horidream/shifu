//
//  PeerToPeerTunnel.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/12/4.
//

import Foundation
import Combine
import Shifu
import SwiftUI
import MultipeerConnectivity

public class PeerToPeerTunnel: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate{
    @Published public var connectedPeers: [MCPeerID] = []
    
    private(set) public var sendingData = PassthroughSubject<(from: MCPeerID , content: Data), Never>()
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true,  session)
    }
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        self.connectedPeers = session.connectedPeers
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        sendingData.send((peerID, data))
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        clg(#function)
        
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        clg(#function)
        
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
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
    private(set) public var isHosting = false
    
    public var displayName: String {
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
    
    public init(_ name:String? = nil, serviceType: String = "shifu"){
        let name = name?.trimmingCharacters(in: .whitespaces).isEmpty ?? true ? UIDevice.current.name : name
        id = MCPeerID(displayName: name ??  UIDevice.current.name)
        session = MCSession(peer: id, securityIdentity: nil, encryptionPreference: .none)
        self.serviceType = serviceType
        super.init()
        session.delegate = self
    }
    public func startHosting(){
        guard !isHosting else { return }
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: id, discoveryInfo: nil, serviceType: serviceType)
        mcNearbyServiceAdvertiser.delegate = self
        mcNearbyServiceAdvertiser.startAdvertisingPeer()
        isHosting = true
    }
    
    public func stopHosting(){
        if let mcNearbyServiceAdvertiser {
            mcNearbyServiceAdvertiser.stopAdvertisingPeer()
        }
        isHosting = false
    }
    
    public func send(_ data: Data) {
        do{
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }catch{
            clg(error)
        }
    }
    
    public var connectionSelectingView: some View {
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
