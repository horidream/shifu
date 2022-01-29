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


let clg = Shifu.clg
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
    @Environment(\.openURL) var openURL
    @State var name:String = "Hello"
    @ObservedObject private var iO = injectionObserver
    var body: some View {
        NavigationView{
            ScrollView{
                Spacer()
                Text(name)
                    .font(.largeTitle)
                    .onAppear(){
                        print("bz - will load data")
                        sc.load("https://jsonplaceholder.typicode.com/todos/1") { (data) in
                            clg(data?.parseJSON()["title"] as? String)
                        }.retain("abc")
                        
                        sc.on(.hello){
                            if let msg = $0.userInfo?["world"] as? String{
                                name = msg
                            }
                        }
                    }
                    .onTapGesture {
                        sc.emit(.hello, userInfo: ["world": "世界 \(Int.random(in: 1...100))"])
                    }
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                
                ForEach((1...5), id:\.self) { value in
                    HStack{
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.red)
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                            .when(value % 2 == 1)
                        VStack{
                            Text("👑宝利👑")
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("有一个愿望可以实现噢 - \(value)").font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.onTapGesture {
                            openURL(URL(string:"mailto:bzhai@paypal.com")!)
                        }
                    }.padding(.horizontal)
                }
                Image(base64String: "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==")
                Spacer()
            }
            .navigationBarTitle(Text("DEMO").when((Int(name.suffix(2)) ?? 0)%2 == 0)+Text(" BB"))
            .navigationBarTitleDisplayMode(.inline)
            .onInjection {
                clg("injected-")
                layoutViews()
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func layoutViews(){
        clg(2)
        //        name = "伟大翟宝利"
    }
}


