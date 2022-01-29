//
//  HomeView.swift
//  Shifu_Example
//
//  Created by Baoli Zhai on 2021/4/6.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import Combine
import Shifu



struct Person:Codable{
    let name:String
    private enum CodingKeys : String, CodingKey {
        case name = "title"
    }
}
extension Notification.Name{
    static var hello = "hello".toNotificationName()
}

struct HomeView: View {
    @State var name:String = "Hello"
    var body: some View {
        
            VStack{
                Text(name)
                    .onAppear(){
                        sc.load("https://jsonplaceholder.typicode.com/todos/1") { (data) in
                            print("loaded")
                            print(UIDevice.current.modelName)
                        }.retain("abc")
                        sc.on(.hello){
                            if let msg = $0.userInfo?["world"] as? String{
                                print("bz - receiving \(msg)")
                                name = msg
                            }
                        }
                    }
                    .onTapGesture {
                        print("bz - tap")
                        sc.emit(.hello, userInfo: ["world": "世界12"])
                    }
                Text("OK")
                Image(base64String: "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==")
            }
            .onAppear(perform: {
                layoutViews()
            })
            .onInjection {
                layoutViews()
            }
            .forceRefresh()
            
        
    }
    
    func layoutViews(){
        name = "OKOKx3"
    }
}


