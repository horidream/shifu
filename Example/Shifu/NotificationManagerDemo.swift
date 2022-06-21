//
//  NotificationManagerDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/6/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct NotificationManagerDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @ObservedObject private var nm = NotificationManager.shared
    var body: some View{
        Group{
            if #available(iOS 16.0, *) {
                HStack{
                    Image(.youtube)
                        .foregroundColor(.red)
                    Text("YouTube")
                }
                .frame(maxHeight: .infinity)

                Text("Notification " + (nm.isGranted ? "Granted" : "Not Granted"))
                HStack{
                    if(nm.isGranted){
                        Button{
                            nm.scheduleLocalNotification(title: "Hello", body: "宝利， 你好！")
                        } label: {
                            Text("Schedule")
                        }.foregroundColor(.purple)
                    }
                    Button{
                        nm.openSettings()
                    } label: {
                        Text("Settings")
                    }
                }
            } else {
                Text("Not Implemented")
            }
        }
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
        .onChange(of: nm.isGranted, perform: { newValue in
            clg("settings is granted:  \(newValue)")
        })
        .onReceive(scenePhase) { _ in
            clg("phase changed")
            nm.refreshSettingsPublisher.send()
        }
    }

    func sandbox(){
        Task{
            try? await nm.requestAuthorization()
        }
    }
}

