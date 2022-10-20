//
//  Home.swift
//  DynamicTabIndicator
//
//  Created by Baoli Zhai on 2022/7/16.
//

import SwiftUI
import Shifu

struct NavigationAnimationDemo: View {
    enum DisplayType{
        case underbar, overlay
    }
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var offset: CGFloat = 0
    @State var type:DisplayType = .underbar
    @State var currentTab = sampleTabs.first!
    @State var shouldIgnoreOffset = false
    @State var timeoutItem: DispatchWorkItem?
    var body: some View {
        GeometryReader{ proxy in
            let screenSize = proxy.size
            ZStack(alignment: .top){
                
                TabView(selection: $currentTab){
                    ForEach(sampleTabs){ tab in
                        ZStack{
                            tab.color
                                .ignoresSafeArea()
                                .onChangePosition { p in
                                    if currentTab == tab && !shouldIgnoreOffset {
                                        let newOffset = p.x - screenSize.width * indexOf(tab: tab).cgFloat
                                        offset = newOffset
                                    }
                                }
                            Image(uiImage: tab.icon.image("PingFang TC Thin", fontSize: 120, fontColor: .white)!)
                                .padding(30)
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .offset(x: 1)
                                }
                        }
                        .tag(tab)
                    }
                    
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                DynamicTabHeader(size: screenSize)
            }
            .frame(width: screenSize.width, height: screenSize.height)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    @ViewBuilder
    func DynamicTabHeader(size: CGSize)-> some View{
        VStack(alignment: .leading, spacing: 22) {
            HStack{
                Text("My Beautiful Navigation")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
                Button{
                    type = type == .underbar ? .overlay : .underbar
                } label: {
                    Image.icon(type == .underbar ? .upLong : .downLong)
                        .foregroundColor(.white)
                        .frame(height: 22)
                }

            }
            HStack(spacing: 0) {
                ForEach(sampleTabs){ tab in
                    Text(tab.name)
                        .fontWeight(.semibold)
                        .padding(.vertical, 6)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .contentShape(Capsule())
                        .onTapGesture {
                            shouldIgnoreOffset = true
                            withAnimation(.easeInOut) {
                                currentTab = tab
                                offset = -size.width * indexOf(tab: tab).cgFloat
                            }
                            
                            timeoutItem?.cancel()
                            timeoutItem =  delay(0.2){
                                shouldIgnoreOffset = false
                            }

                        }
                        
                }
            }
            .if(type == .underbar){ v in
                v.background(alignment: .bottomLeading) {
                    Capsule()
                        .fill(.white)
                        
                        .frame(width: (size.width - 30) / sampleTabs.count.cgFloat , height: 4)
                        .offset(y: 12)
                        .offset(x: tabOffset(size: size, padding: 30))
                }
            }
            .if(type != .underbar ){
                v in
                v.overlay(alignment: .leading) {
                    Capsule()
                        .fill(.white)
                        .overlay(alignment: .leading, content: {
                            HStack(spacing: 0) {
                                ForEach(sampleTabs){ tab in
                                    Text(tab.name)
                                        .fontWeight(.semibold)
                                        .if(type != .underbar){
                                            $0.padding(.vertical, 6)
                                        }
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity)
                                }
                                .offset(x: -tabOffset(size: size, padding: 30))
                            }
                            .frame(width: size.width - 30)
                        })
                        .frame(width: (size.width - 30) / sampleTabs.count.cgFloat)
                        .mask(Capsule())
                        .offset(x: tabOffset(size: size, padding: 30))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background{
            Rectangle()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .ignoresSafeArea()
        }
        
        
        
    }
    func tabOffset(size: CGSize, padding: CGFloat)->CGFloat{
        return -offset / size.width * (size.width - padding) / sampleTabs.count.cgFloat
    }
    func indexOf(tab: Tab)->Int{
        return sampleTabs.firstIndex(of: tab) ?? 0
    }
    func sandbox(){
        clg("OK  ")
    }
}


struct Tab: Identifiable, Hashable{
    var id = UUID().uuidString
    var name: String
    var color: Color
    var icon: String
}


var sampleTabs = [
    Tab(name: "Red", color: .red, icon: "红"),
    Tab(name: "Blue", color: .blue, icon: "蓝"),
    Tab(name: "Green", color: .green, icon: "绿")
]
