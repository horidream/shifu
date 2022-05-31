//
//  PowerTableDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 2022/5/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import Shifu
import JavaScriptCore
import Combine
import UIKit

struct PowerTableDemo:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var snapshot:NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>  = {
        var snapshot = NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>()
        snapshot.appendSections(["A", "B"])
        snapshot.appendItems((1...2).map{AnyDiffableData("\($0)")}, toSection: "A")
        snapshot.appendItems((10...12).map{AnyDiffableData("\($0)")}, toSection: "B")
        return snapshot
    }()
    var body: some View{
        PowerTable(snapshot: $snapshot)
            .onTapGesture {
                snapshot.addSection("八仙过海")
                snapshot.appendItems([AnyDiffableData(Int.random(in: 100...200).stringify())])
            }
            .navigationTitle("Sandbox")
            .onInjection{
                sandbox()
            }
            .onAppear{
                sandbox()
            }
    }
    
    func sandbox(){
        
        
    }
}


extension UITableViewCell: Updatable{
    public func update(_ data: Any?)  {
        if let data = data as? AnyDiffableData, let text = data.payload as? String{
            self.textLabel?.text = text
        }
    }
}
