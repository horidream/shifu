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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Persist("YouglishWebViewDemo_History") var history:[String] = []{
        didSet{
            if(history.count > 30){
                history = Array(history[..<30])
            }
            if(!history.contains(currentSearch)){
                currentSearch = ""
            }
        }
    }
    @State var shouldHistorySearchVideo = true
    @ObservedObject private var injectObserver = Self.injectionObserver
    @EnvironmentObject var vm: HomeViewModel
    @AppStorage("currentSearch") var currentSearch: String = "disparity"
    
    @State var inputText = ""
    @State var lastSearch:String?
    @State var searching = true
    @Tween var anime;
    // the following properties is to mirror the states in webpage
    @State var isPlaying = false
    @State var prevBtnEnabled = false
    @State var nextBtnEnabled = false
    @State var shouldResume = true
    @FocusState var shouldFocusOnInput:Bool
    @State var ratio = 398.0 / 323.0
    var playerSize: CGSize {
        let w = min(vm.g?.size.width ?? env.width, 800)
        return CGSize(width: w, height:  floor(w / ratio) - 2)
    }
    var shouldShowWebView: Bool {
        return !searching
    }
    
    @discardableResult private func updateYouglish(_ newValue: String)->Bool{
        if let searchingWord = newValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), searchingWord != lastSearch, !searchingWord.isEmpty{
            lastSearch = searchingWord
            vm.youglish.url = "https://youglish.com/pronounce/\(searchingWord)/english?".url
            isPlaying = false
            return true
        }
        vm.youglish.url = nil
        return false
    }
    
    fileprivate func doSearch(_ newValue: String) {
        showDefinition(newValue)
        if(updateYouglish(newValue)){
            shouldResume = true
            
            tl($anime).to([\.rotationY: 90]).perform {
                searching = true
            }.set([\.rotationY: -90]).to([\.rotationY: 0])
            if(!history.contains(newValue)){
                history.insert(newValue, at: 0);
            } else {
                if let idx = history.firstIndex(of: newValue){
                    var arr = history
                    let elementToMove = arr.remove(at: idx)
                    arr.insert(elementToMove, at: 0)
                    history = arr
                }
            }
        }
        inputText = newValue
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
                        .onSubmit {
                            currentSearch = inputText
                        }
                        .focused($shouldFocusOnInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay{
                            if(!inputText.isEmpty){
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        inputText = ""
                                        shouldFocusOnInput = true
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                    Button{
                        currentSearch = inputText
                    } label: {
                        Image(.magnifyingglass)
                    }
                    Button{
                        showDefinition(inputText)
                    } label: {
                        Image.resizableIcon(.characterBookClosedFill, size: 24)
                            .frame(height: 28)
                    }
                }
                .padding(0, 0, 5)
                ZStack{
                    ShifuWebView(viewModel: with(vm.youglish){
                        $0.allowedMenus = ["copy", "define"];
                        $0.extraMenus = [localized("Search Video"): {
                            currentSearch = $0
                        }]
                    })
                    .opacity(shouldShowWebView ? 1 : 0)
                    .id("youtube-video")
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.background.swiftUIColor)
                        .overlay(
                            VStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                                    .frame(height: playerSize.width * 1/2)
                                    .overlay(
                                        Text(vm.youglish.url == nil ? "No Video" : "Loading")
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
                    }.disabled(!prevBtnEnabled)
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
                    }.disabled(!nextBtnEnabled)
                }
                .frame(maxWidth: 400)
                .padding(.horizontal, 32)
                VStack{
                    Toggle(shouldHistorySearchVideo ?  localized("Video & Definition") : localized("Definition Only"), isOn: $shouldHistorySearchVideo)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3)) // Set the color of the line
                        .frame(height: 1)  // Set the width of the line
                    SimpleFlowText(items: $history) { text in
                        if(currentSearch != text && shouldHistorySearchVideo){
                            currentSearch = text
                        } else {
                            showDefinition(text)
                        }
                    }  onLongPress: { text in
                        if let idx = history.firstIndex(of: text){
                            history.remove(at: idx);
                        }
                    }
                }
                
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(35,0,20)
            }
            .padding()
            .frame(maxWidth: playerSize.width)
            .onChange(of: currentSearch, perform: doSearch)
            .on("onPlayerReady"){ _ in
                tl($anime).to([\.rotationY: 90], duration: 0.5).perform {
                    searching = false
                }.set([\.rotationY: -90]).to([\.rotationY: 0.5]).perform{
                    modifyWebpage()
                    calculateRatio()
                }
            }
            .on("playingChange"){ no in
                cleanWebUI()
                isPlaying = no.userInfo?["isPlaying"] as? Bool ?? false
            }
            .on("btnChanged"){ no in
                if let info = no.userInfo?["details"] as? NSDictionary, let name = info["name"] as? String, let value = info["value"] as? Bool {
                    switch(name) {
                    case "prev":
                        prevBtnEnabled = !value
                    case "next":
                        nextBtnEnabled = !value
                    default:()
                        
                    }
                }
            }
            .on("ready"){ _ in
                modifyWebpage()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .onInjection {
                sandbox()
            }
            
            .onAppear {
                doSearch(currentSearch)
            }
        }
    }
    
    func showDefinition(_ word: String){
        let word = word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard word != "" else { return }
        shouldResume = shouldResume || isPlaying
        if(isPlaying){
            click("#b_pause")
        }
        let vc = SFHostingController(rootView: DefinitionView(word: word))
        sc.on("dismiss", object: vc){ _ in
            if(!isPlaying && shouldResume){
                click("#b_pause")
                shouldResume = false
            }
        }
        if let presentationController = vc.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()] /// change to [.medium(), .large()] for a half *and* full screen sheet
        }
        _rootViewController.present(vc, animated: true)
    }
    
    func cleanWebUI(){
        vm.youglish.apply("""
    $(".g_pr_ad_network, .card, footer, header, .search, #ttlr, #all_actions, avp-player-ui").remove();
""")
    }
    func sandbox() {
        
    }
    
    func click(_ name:String){
        vm.youglish.apply("""
$("\(name)").click();
""")
    }
    func modifyWebpage(){
        if(colorScheme == .dark){
            vm.youglish.apply(MODIFY_PAGE.replace(pattern: "\\{1\\}", with: "theme_light" ).replace(pattern: "\\{2\\}", with: "theme_dark"))
        } else {
            vm.youglish.apply(MODIFY_PAGE.replace(pattern: "\\{1\\}", with: "theme_dark" ).replace(pattern: "\\{2\\}", with: "theme_light"))
        }
    }
    
    func calculateRatio(){
        vm.youglish.apply("""
function calculateUnionRect(div1, div2) {
  var rect1 = div1.getBoundingClientRect();
  var rect2 = div2.getBoundingClientRect();

  var top1 = rect1.top;
  var top2 = rect2.top;
  var bottom1 = rect1.bottom;
  var bottom2 = rect2.bottom;

  var left1 = rect1.left;
  var left2 = rect2.left;
  var right1 = rect1.right;
  var right2 = rect2.right;

  var maxBottom = Math.max(bottom1, bottom2);
  var minTop = Math.min(top1, top2);
  var minLeft = Math.min(left1, left2);
  var maxRight = Math.max(right1, right2);

  return {x: minLeft, y: minTop, width: maxRight - minLeft, height: maxBottom - minTop};
}

var div1 = document.getElementById("videowrapper");
var div2 = document.getElementById("captioncont");
var calculateUnionRect = calculateUnionRect(div1, div2);
return calculateUnionRect;
"""){ rst in
            if let rect = rst as? NSDictionary, let w = rect["width"] as? CGFloat, let h = rect["height"] as? CGFloat {
                delay(0){
                    if(self.ratio != w/h){
                        self.ratio = w/h
                    }
                }
            }
        }
    }
    
}



private let MODIFY_PAGE = """
if (typeof $ != "undefined") {
    $(".result_container").parents().addBack().show();
    $(".result_container").children(":last-child").remove();
    $(".g_pr_ad_network, .card, footer, header, .search, #ttlr, #all_actions, avp-player-ui").remove();
    $(".togglecaps").hide();
    $("#controlID").css("maxHeight", "0");
    $("#controlID").css("visibility", "hidden");
    $("#ctn_fix_caption").css("pointer-events", "none");
    $(".toggle-light-listener").removeClass("{1}").addClass("{2}");
}
observe("#b_pause > img", "src", (target) => {
    let isPlaying = target.src.indexOf("pause") > -1;
    postToNative({ type: "playingChange", isPlaying });
});
observe(["#b_prev", "#b_next"], "class", (target, selector) => {
    postToNative({
        type: "btnChanged",
        details: {
            name: selector.slice(3),
            value: target.classList.contains("disable"),
        },
    });
});

"""

