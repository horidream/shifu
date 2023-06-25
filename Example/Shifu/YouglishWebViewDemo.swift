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
import UIKit



struct YouglishWebViewDemo: View {
    
    @ObservedObject private var injectObserver = Self.injectionObserver
    @AppStorage("currentSearch") var currentSearch: String = "disparity"{
        didSet{
            doSearch(currentSearch)
        }
    }
    @StateObject var model:ShifuWebViewModel = {with(ShifuWebViewModel()){ vc in
        vc.log2EventMap = ["onPlayerReady": "onPlayerReady"]
        vc.treatLoadedAsMounted = true
        vc.shared = true
    }
    }()
    @State var inputText = ""
    @State var searching = true
    @State var isPlaying = false
    @Tween var anime;
    var playerSize: CGSize {
        let w = min(env.width, 512)
        return CGSize(width: w, height:  w * 5/6)
    }
    var shouldShowWebView: Bool {
        return !searching
    }
    
    fileprivate func doSearch(_ newValue: String) {
        showDefinition(newValue)
        if let searchingWord = newValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed){
            model.url = "https://youglish.com/pronounce/\(searchingWord)/english?".url
            inputText = newValue
            isPlaying = false
            tl($anime).to([\.rotationY: 90]).perform {
                searching = true
            }.set([\.rotationY: -90]).to([\.rotationY: 0])
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack(alignment: .center){
                     ShifuPasteButton {
                        Image(.paste, size: 28)
                    } onPaste: { _ in
                        if let text = pb.string, !text.isEmpty {
                            currentSearch = text
                        }
                    } config: { conf in
                        //                        conf.forceLegacy = true
                    }
                    
                    TextField("Search", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay{
                            if(!inputText.isEmpty){
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        inputText = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                            Button{
                                doSearch(inputText)
                            } label: {
                                Image(.magnifyingglass)
                            }
                            Button{
                                currentSearch = inputText
                            } label: {
                                Image.resizableIcon(.characterBookClosedFill, size: 24)
                                    .frame(height: 28)
                            }
                        }
                        .padding(0, 20, 12)
                    ZStack{
                        ShifuWebView(viewModel: model)
                            .opacity(shouldShowWebView ? 1 : 0)
                            .id("youtube-video")
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .overlay(
                                VStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 1)
                                        .frame(height: playerSize.width * 1/2)
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
                    .frame(width: playerSize.width, height: playerSize.height)
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
                }
                .padding()
                .frame(maxWidth: 512)
                .onChange(of: currentSearch, perform: doSearch)
                .on("onPlayerReady"){ _ in
                    modifyWebpage()
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
        
        func showDefinition(_ word: String){
            if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word) {
                let vc = UIHostingController(rootView: DefinitionView(word: word))
                if let presentationController = vc.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                }
                _rootViewController.present(vc, animated: true)
            }
        }
        func sandbox() {
            doSearch(currentSearch)
            modifyWebpage()
        }
        
        func click(_ name:String){
            model.apply("""
$("\(name)").click();
""")
        }
        func modifyWebpage(){
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
    
    

