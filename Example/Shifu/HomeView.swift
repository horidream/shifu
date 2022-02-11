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
    @StateObject var vm = HomeViewModel()
    @ObservedObject private var injectObserver = Self.injectionObserver
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("Examples").font(.headline).padding(10)) {
                    ForEach(vm.featureList, id: \.name){ feature in
                        NavigationLink {
                            feature.view
                        } label: {
                            HStack{
                                Text(feature.name)
                                    .frame(maxWidth: .infinity, alignment: .leading )
                                    .contentShape(Rectangle())
                                    .padding(12)
                            }
                        }
                    }
                }
                
            }
            .environmentObject(vm)
            .listStyle(.plain)
            .navigationBarTitle(Text("Shifu"))
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
        vm.refresh()
    }
}
