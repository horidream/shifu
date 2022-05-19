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
    @State var content = "## haha\n\n Hello world"
    @State var datasource:UITableViewDiffableDataSource<String, String>!
    @State var isOn = false
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
                    SimpleMarkdownViewer(content: content, config: "theme.current = 'dark'")
                        .frame(width: 300, height: 100)
                        .padding()
                        .background(.white.opacity(0.3))
                        .cornerRadius(10)
                }
            } else {
                VStack(){
                    Spacer()
                    Circle()
                        .matchedGeometryEffect(id: "AlbumTitle", in: animation)
                        .frame(width: 100, height: 100)
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
        rootViewController.view.viewWithTag(99)?.removeFromSuperview()
        //        let tableView = UITableView()
        //        tableView.tag = 99
        //        rootViewController.view.addSubview(tableView)
        //        tableView.quickMargin(0,0,0,0)
        //        tableView.delegate = TestDelegate.shared
        //
        //        // setup datasource
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //        // You need to retain the datasource property
        //        datasource = UITableViewDiffableDataSource<String, String>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        //            cell?.backgroundColor = indexPath.section == 0 ? .purple : .blue
        //            cell?.textLabel?.textColor = .white
        //            cell?.textLabel?.text = "Item: \(itemIdentifier)"
        //            return cell
        //        }
        //        // update datasource
        //        let data = [("0", ["1", "2", "3"]), ("B", ["4", "5", "6"])]
        //        applySnapshot(data: data)
        //
        //        print(data.map{ $0.0 })
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
