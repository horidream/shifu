//
//  Sandbox.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit

struct Sandbox:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var content = ""
    @State var datasource:UITableViewDiffableDataSource<String, String>!
    @State var isOn = false
    @State var isDark = true
    @Namespace var animation
    var body: some View{
        Group{
            if isOn {
                ZStack{

                    Circle()
                        .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                        .frame(width: 1200, height: 1200)
                        .foregroundColor(.yellow)
                        .ignoresSafeArea()
                    SimpleMarkdownViewer(content: content, config: "theme.current = '\(isDark ? "dark": "light")'")
                        .id(content + "\(isDark)")
                        .frame(width: 300)
                        .padding()
                        .background((isDark ? Color.black: Color.white).opacity(0.5))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 5, y: 5)
//                        .rotation3DEffect(.degrees(45), axis: (0,1,0), perspective: 1)
                }
            } else {
                VStack(){
                    Spacer()
                    Circle()
                        .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.yellow)
                        .padding()
                }
                
            }
        }
        .navigationTitle("Sandbox")
        .onTapGesture {
            withAnimation {
                isOn.toggle()
                
            }
        }
        
        .onInjection{
            sandbox()
        }
        .onAppear{
            sandbox()
        }
    }
    
    func sandbox(){
        isDark = true
        content = "![](https://cdn.i-scmp.com/sites/default/files/styles/1200x800/public/d8/video/thumbnail/2021/08/14/lotr.jpg?itok=y_dh_Rrp)<br><br>\nMay it be an evening star    \nShines down upon you    \nMay it be when darkness falls    \nYour heart will be true    \nYou walk a lonely road    \nOh, how far you are from home    \nMornie utulie    \nBelieve and you will find your way    \nMornie alantie    \nA promise lives within you now    \nMay it be the shadow's call will fly away    \nMay it be your journey on to light the day    \nWhen the night is overcome    \nYou may rise to find the sun    \nMornie utulie    \nBelieve and you will find your way    \nMornie alantie    \nA promise lives within you now    \nA promise lives within you now"
    }
    
    var navi: UINavigationController? {
        return rootViewController.children.first as? UINavigationController
    }
    
    
    func applySnapshot(data: [(String, [String])]){
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        for (section, items) in data{
            snapshot.appendSections([section])
            snapshot.appendItems(items)
        }
        datasource.apply(snapshot)
    }
}




class TestDelegate: NSObject, UITableViewDelegate {
    static let shared:TestDelegate = TestDelegate()
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        clg("can give you")
        if let datasource = tableView.dataSource as? UITableViewDiffableDataSource<String, String>{
            label.text = datasource.sectionIdentifier(for: section)
            label.textColor = .black
        }
        return label
    }
}
