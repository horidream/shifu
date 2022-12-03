//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/9/2.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import ShifuWebServer
import UniformTypeIdentifiers
import CoreServices
import Combine
import PencilKit
import SwiftSoup
import VisionKit

struct ChatItem:Identifiable, Hashable{
    let id = UUID()
    let user: String
    let content: String
}

struct Sandbox: View {
    
    @EnvironmentObject var tunnel: PeerToPeerTunnel
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var shouldJoinPeer = false
    @State var msg = [ChatItem]()
    @State var msgToSend = ""
    @Persist("displayName") var name = UIDevice.current.name
    @FocusState private var focus:Bool?
    @State var bottomID = UUID()
    var body: some View {
        
        ScrollView{
            ScrollViewReader { value in
                ForEach(msg){ item in
                    let isSelf = item.user == name
                    HStack{
                        if isSelf {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 0){
                                Text(item.user)
                                    .font(.caption2)
                                    .foregroundColor(Color.gray.opacity(0.7))
                                    .padding(.trailing, 8)
                                Text(item.content)
                                    .foregroundColor(.white)
                                    .frame(alignment:  .trailing)
                                    .padding(10)
                                    .background(Color.green)
                                    .cornerRadius(20)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 0){
                                Text(item.user)
                                    .font(.caption2)
                                    .foregroundColor(Color.gray.opacity(0.7))
                                    .padding(.leading, 8)
                                Text(item.content)
                                    .foregroundColor(.white)
                                    .frame(alignment:  .leading)
                                    .padding(10)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                            Spacer()
                        }
                    }
                }
                Color.clear
                    .id(bottomID)
                    .onChange(of: msg) { newValue in
                        value.scrollTo(bottomID)
                    }
            }
            .padding(.horizontal, 20)
        }
        
        HStack(spacing: 10){
            Button{
                shouldJoinPeer.toggle()
            } label: {
                Image.resizableIcon(.link_sf)
                    .frame(width: 22, height: 22)
                    .padding(10)
                    .overlay {
                        Circle() // or RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 2)
                    }
            }
            TextEditor(text: $msgToSend)
                .padding(.horizontal, 10)
                .frame(height: 38)
                .onChange(of: msgToSend, perform: { newValue in
                    guard !newValue.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    if msgToSend.substr(-2) == "\n\n" {
                        sendMessage()
                    }
                })
                .overlay{
                    RoundedRectangle(cornerRadius: 30, style: .circular)
                        .stroke(lineWidth: 1)
                }
                
            if tunnel.connectedPeers.count > 0{
                Button{
                    sendMessage()
                } label: {
                    Image.resizableIcon(.paperplane)
                        .frame(width: 22, height: 22)
                        .padding(10)
                        .overlay {
                            Circle()
                                .stroke(.blue, lineWidth: 2)
                        }
                }
            }
                
            
        }
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                TextField( UIDevice.current.name, text: $name)
                    .padding(.horizontal, 10)
                    .focused($focus, equals: true)
                    .onChange(of: focus, perform: { newValue in
                        if focus != true {
                            tunnel.displayName = name.isEmpty ? UIDevice.current.name : name
                        }
                    })
                    .frame(height: 30)
                    .overlay{
                        RoundedRectangle(cornerRadius: 30, style: .circular)
                            .stroke(lineWidth: 1)
                    }
                    .padding(.vertical, 10)
            }
        })
        .onReceive(tunnel.sendingData, perform: { (from, data) in
            msg.append(ChatItem(user: from.displayName, content: data.utf8String ?? ""))
        })
        
        .sheet(isPresented: $shouldJoinPeer){
            tunnel.connectionSelectingView
        }
        .onInjection {
            sandbox()
        }
        .onAppear {
            sandbox()
        }
        
    }
    
    func sendMessage(){
        guard tunnel.connectedPeers.count > 0 else { return }
        let message = msgToSend.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        tunnel.send(message.data(using: .utf8)!)
        msg.append(ChatItem(user: name, content: message))
        msgToSend = ""
    }
    
    func sandbox() {
        tunnel.displayName = name
        if !tunnel.isHosting {
            tunnel.startHosting()
        }
    }
    
}

