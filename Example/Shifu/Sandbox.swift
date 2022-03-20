//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var locale:Locale = .zh_CN
    @State var progress: CGFloat = 0
    @State var displayMessage:String = ""
    @State var currentColor:Color = .white
    @State var prevColor:Color = .white
    @State var isSilent: Bool = false
    let paddingValue:CGFloat = 50
    let timer = Timer.publish(every: 60 , on: RunLoop.main, in: .common)
        .autoconnect()
        .prepend(Date())
    var body: some View{
        ZStack{
            VStack{
                Text(displayMessage)
                    .bold()
                    .foregroundColor(.white)
                    .padding(12, 16)
                    .background(
                        Capsule()
                            .fill(Color.blue)
                    )
                
            }
            
            Circle()
                .stroke(Color.blue.opacity(0.73), style: StrokeStyle(lineWidth: 70, lineCap: .round, lineJoin: .round))
                .padding(paddingValue)
            Circle()
                .stroke(prevColor, style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                .padding(paddingValue)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(currentColor, style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: -84))
                .padding(paddingValue)
            
        }
        .onChange(of: isSilent, perform: { newValue in
            if newValue {
                Announcer.shared.stop()
            }else{
                Announcer.say(displayMessage)
            }
        })
        .onReceive(timer, perform: render(date:))
        .onTapGesture {
            isSilent.toggle()
        }
        .onInjection {
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func render(date: Date){
        let msg = date.toString(formatter: .formatter(with:"yyyyMMMMddhhmm", timeZone: .gmt + 9, locale: locale)) ?? ""
        
        ta($progress).from(0, to: 1, duration: 60)
        prevColor = currentColor
        ta($currentColor).to(.random, duration: 5)
        displayMessage = msg
        if(!isSilent){
            Announcer.say(msg, wait: false,  locale: locale)
        }
    }
    
    func sandbox(){
        clg("hot reloading!!")
        
    }
}
