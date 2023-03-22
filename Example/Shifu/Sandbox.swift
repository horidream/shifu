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



struct Sandbox: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @StateObject var model = with(ShifuWebViewModel()){
        $0.url = "https://youglish.com/pronounce/disparity/english".url
        $0.treatLoadedAsMounted = true
    }
    @State var searchText = ""
    @State var searching = true
    @State var isPlaying = false
    var shouldShowWebView: Bool {
        return model.isMounted && !searching
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button{
                        model.apply("""
        $("#q").val(searchText);
        $("#searchbut").click();
        """, arguments: ["searchText": searchText])
                    isPlaying = false
                        searching = true
                } label: {
                    Image(.magnifyingglass)
                }
            }
            .padding(.bottom, 20)
            ShifuWebView(viewModel: model)
                .frame(width: env.width, height: env.width * 5/6)
//                .scaleEffect(1.076)
                
                .opacity(shouldShowWebView ? 1 : 0)
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
            .padding(.horizontal, 20)
            Spacer()


            
        }
        .padding()
        .on("onPlayerReady"){ _ in
            searching = false
            hideWebViewUI()
        }

        .on("playingChange"){ no in
            clg(no)
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
    
    func sandbox() {
        hideWebViewUI()
    }
    
    func click(_ name:String){
        model.apply("""
$("\(name)").click();
""")
    }
    func hideWebViewUI(){
        model.apply("""
$("body *").not(".result_container, .result_container *").hide();
$(".result_container").parents().addBack().show();

$(".result_container").children(":last-child").hide();
$(".togglecaps").hide();
$("#controlID").css("maxHeight", "0");
$("#controlID").css("visibility", "hidden");
const myDiv = document.querySelector("#b_pause > img");
if(observer){
    observer.disconnect();
}
const observer = new MutationObserver(mutationsList => {
    for (let mutation of mutationsList) {
        if (mutation.type === 'attributes' && mutation.attributeName === 'src') {
            let isPlaying = myDiv.src.indexOf("pause") > -1
            postToNative({type: "playingChange", isPlaying});
        }
    }
});
observer.observe(myDiv, { attributes: true });
""", arguments: ["force": true])
    }
    
}

