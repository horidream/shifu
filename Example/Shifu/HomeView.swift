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
    @Environment(\.openURL) var openURL
    @State var name:String = "Hello"
    @State var phase:ScenePhase = scenePhase.value
    @ObservedObject private var iO = Self.injectionObserver
    let cvp = "Baoli".cvp
    
    var body: some View {
        NavigationView{
            ScrollView{
                titleArea()
                listArea()
                canvasArea()
            }
            .navigationBarTitle(Text("DEMO" + " - \(phase)").when((Int(name.suffix(2)) ?? 0) % 2 == 0)+Text(" Hori"))
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(scenePhase, perform: { sp in
                clg("scene phase", sp)
                if sp == .background{
                    UIApplication.shared.shortcutItems = [
                        UIApplicationShortcutItem(type: "Hello", localizedTitle: "Hello", localizedSubtitle: "say hello", icon: UIApplicationShortcutIcon(systemImageName: "helm"), userInfo: nil)
                    ]
                }
            })
            .onAppear(){
                sandbox()
            }
            .onInjection {
                sandbox()
                clg("injected")
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func sandbox(){
        if #available(iOS 15, *) {
            clg("date now - ", Date.now.timeIntervalSinceReferenceDate)
            clg("date now - ", (Date()).timeIntervalSinceReferenceDate)
            clg("date now - ", Date.now.timeIntervalSince1970)
        } else {
            // Fallback on earlier versions
        }
        
    }
}

extension HomeView{
    @ViewBuilder fileprivate func canvasArea() -> some View {
        if #available(iOS 15.0, *) {
            GeometryReader{ proxy in
            TimelineView(.animation){ timeline in
                Canvas{ context, size in
                    context.draw(Image(systemName: "helm"), at: CGPoint(proxy.size.width/2,proxy.size.height/2))
                }
            }
            }
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
            .frame(height: 320)
            
        } else {
            // Fallback on earlier versions
        }
        Spacer()
    }
    
    @ViewBuilder fileprivate func listArea() -> some View {
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
                    Text("宝利")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("有一个愿望可以实现噢 - \(value)").font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.onTapGesture {
                    openURL(URL(string:"mailto:bzhai@paypal.com")!)
                }
            }.padding(.horizontal)
        }
    }
    
    @ViewBuilder fileprivate func titleArea() -> some View {
        Spacer()
        Text(name)
            .font(.largeTitle)
            .onAppear(){
                clg("will load data")
                sc.load("https://jsonplaceholder.typicode.com/todos/1") { (data) in
                    clg(data?.parseJSON()["title"] as? String)
                    clg("stringify: ", JSON.stringify(JSON.parse(data)))
                }.retain("abc")
                
                sc.on(.hello){
                    if let msg = $0.userInfo?["world"] as? String{
                        name = msg
                    }
                }
            }
            .onTapGesture {
                sc.emit(.hello, userInfo: ["world": "世界 - \(Int.random(in: 1...100))"])
                cvp.value = "test \(Int.random(in: 1...100))"
            }
        Rectangle()
            .foregroundColor(.gray)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
    }
}

