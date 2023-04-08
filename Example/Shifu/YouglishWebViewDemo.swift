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
import AVKit



struct YouglishWebViewDemo: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @AppStorage("lastSearch") var lastSearch: String = "disparity"
    @StateObject var model:ShifuWebViewModel = {with(ShifuWebViewModel()){ vc in
        //        vc.url = vc.sharedShifuWebViewController.webView.url ?? "https://youglish.com/pronounce/\(lastSearch)/english".url
        vc.log2EventMap = ["onPlayerReady": "onPlayerReady"]
        vc.treatLoadedAsMounted = true
        vc.shared = true
    }
    }()
    @State var searchText = ""
    @State var searching = true
    @State var isPlaying = false
    @Tween var anime;
    var shouldShowWebView: Bool {
        return !searching
    }
    
    fileprivate func doSearch(_ newValue: String) {
        if let safeword = newValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed){
            clg(safeword)
            model.url = "https://youglish.com/pronounce/\(safeword)/english".url
            lastSearch = newValue
            searchText = newValue
            isPlaying = false
            tl($anime).to([\.rotationY: 90]).perform {
                searching = true
            }.set([\.rotationY: -90]).to([\.rotationY: 0])
        }
        //        model.apply("""
        //        $("#q").val(searchText);
        //        $("#searchbut").click();
        //        console.log("what?")
        //        """, arguments: ["searchText": searchText])
        
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack(alignment: .center){
                    ShifuPasteButton {
                        Image(.paste)
                    } onPaste: { _ in
                        if let text = pb.string, !text.isEmpty {
                            lastSearch = text
                        }
                    }
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button{
                        doSearch(searchText)
//                        lastSearch = searchText
                    } label: {
                        Image(.magnifyingglass)
                    }
                    
                    
                }
                .padding(0, 20, 12)
                ZStack{
                    ShifuWebView(viewModel: model)
                        .opacity(shouldShowWebView ? 1 : 0)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .overlay(
                            VStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                                    .frame(height: env.width * 1/2)
                                    .overlay(
                                        Text("Loading")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                    )
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            }
                        )
                        .padding(12, 20, 32)
                        .opacity(shouldShowWebView ? 0 : 1)
                }
                .frame(width: env.width, height: env.width * 5/6)
                .tweenProps(anime)
                HStack(){
                    let ns = 30.0
                    let ls = 45.0
                    Button{
                        click("#b_prev")
                        
                    } label: {
                        Image.resizableIcon(.backwardFrame)
                            .frame(width: ns, height: ns)
                    }
                    Spacer()
                    Button{
                        click("#b_back")
                    } label: {
                        Image.resizableIcon(.gobackward5)
                            .frame(width: ns, height: ns)
                    }
                    Spacer()
                    Button{
                        click("#b_pause")
                    } label: {
                        Image.resizableIcon(isPlaying ? .pause_sf : .play_sf)
                            .frame(width: ls, height: ls)
                    }
                    Spacer()
                    Button{
                        click("#b_replay")
                        
                        
                    } label: {
                        Image.resizableIcon(.gobackward)
                            .frame(width: ns, height: ns)
                    }
                    Spacer()
                    Button{
                        click("#b_next")
                        
                    } label: {
                        Image.resizableIcon(.forwardFrame)
                            .frame(width: ns, height: ns)
                    }
                }
                .padding(.horizontal, 32)
                Spacer()
                    .frame(minHeight: 50)
//                Text(model.bridge.stringify() ?? "")
//                Button{
//                    model.apply("""
//bridge.a = \(Int.random(in: 0...100))
//""")
//                } label: {
//                    Text("test")
//                }
                
                
                
            }
            .padding()
            .onChange(of: lastSearch, perform: doSearch)
            .on("onPlayerReady"){ _ in
                hideWebViewUI()
            }
            .on("goodToGo"){ _ in
                tl($anime).to([\.rotationY: 90]).perform {
                    searching = false
                }.set([\.rotationY: -90]).to([\.rotationY: 0])
            }
            .on("playingChange"){ no in
                isPlaying = no.userInfo?["isPlaying"] as? Bool ?? false
            }
            .navigationBarTitleDisplayMode(.inline)
            .onInjection {
                sandbox()
            }
            
            .onAppear {
                sandbox()
            }
            
        }
    }
    func sandbox() {
        doSearch(lastSearch)
        searchText = lastSearch
        hideWebViewUI()
    }
    
    func click(_ name:String){
        model.apply("""
$("\(name)").click();
""")
    }
    func hideWebViewUI(){
        model.apply("""
if(typeof $ != "undefined"){
    $("body *").not(".result_container, .result_container *").hide();
    $(".result_container").parents().addBack().show();

    $(".result_container").children(":last-child").hide();
    $(".togglecaps").hide();
    $("#controlID").css("maxHeight", "0");
    $("#controlID").css("visibility", "hidden");
    $("#ctn_fix_caption").css("pointer-events", "none");
}
const myDiv = document.querySelector("#b_pause > img");
if(myDiv){
    globalThis.observer?.disconnect();
    globalThis.observer = new MutationObserver(mutationsList => {
        for (let mutation of mutationsList) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'src') {
                let isPlaying = myDiv.src.indexOf("pause") > -1
                postToNative({type: "playingChange", isPlaying});
            }
        }
    });
    globalThis.observer.observe(myDiv, { attributes: true });
    postToNative({type: "goodToGo"})
}
""")
    }
    
}

