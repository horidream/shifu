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
    @StateObject var colorManager = ColorSchemeMananger()
    @ObservedObject private var iO = Self.injectionObserver
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("Examples").font(.headline).padding(10)) {
                    ForEach(0..<vm.featureList.count){ idx in
                        
                        NavigationLink(isActive: $vm.featureList[idx].isActive, destination: {
                            vm.featureList[idx].view
                        }, label: {
                            HStack{
                                Text(vm.featureList[idx].name)
                                    .frame(maxWidth: .infinity, alignment: .leading )
                                    .contentShape(Rectangle())
                                    .padding(12)
                            }
                        })
                            .onTapGesture {
                                vm.featureList[idx].isActive = true
                                vm.objectWillChange.send()
                            }
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationBarTitle(Text("Shifu"))
            .onAppear(){
                colorManager.applyColorScheme()
            }
            .onInjection {
                vm.refresh()
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .environmentObject(vm)
        .environmentObject(colorManager)
        
    }
    
    func sandbox(){
        
    }
}

func runOnce(file:String = #file, line:Int = #line, block:()->Void){
    let id = "\(file)-\(line)"
    class Status {
        static var dic = [String: Bool]()
        static func canRun(_ id:String)->Bool{
            return dic[id] ?? true
        }
        static func didRun(_ id:String){
            dic[id] = false
        }
    }

    if(Status.canRun(id)){
        block()
        Status.didRun(id)
    }
}
