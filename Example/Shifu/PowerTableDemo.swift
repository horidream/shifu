//
//  PowerTableDemo.swift
//  ShifuExample
//
//  Created by Baoli Zhai on 1222/5/28.
//  Copyright © 1222 CocoaPods. All rights reserved.
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
        snapshot.appendItems((1...2).map{AnyDiffableData("Super Man \($0)")}, toSection: "A")
        snapshot.appendItems(["We won’t define default parameters at the Baz nor BazMock but we will use a protocol extension which will be the only place that the default values will be defined. That way both implementations of the same protocol have the same default values."], toSection: "B")
        return snapshot
    }()
    var body: some View{
        PowerTable(snapshot: $snapshot, delegate: MyCo())
            .onTapGesture {
                snapshot.addSection(DiffableDataFactory.headerAndFooter("オリジナル劇場アニメ", footer: "2019 年 ‧ 科幻/爱情 ‧ 1 小时 38 分钟"))
                snapshot.appendItems([AnyDiffableData(Int.random(in: 100...120).stringify())])
            }
            .navigationTitle("PowerTable Demo")
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



class MyCo: PowerTable.Coordinator{
    override init(){
        super.init()
        self.defaultHeaderViewClass = MyLabel.self
        self.style = .plain
    }
}

class MyLabel: UILabel, Updatable{
    public func update(_ data: Any?) {
        self.backgroundColor = .darkGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 12
        paragraphStyle.headIndent = 12
        paragraphStyle.tailIndent = -12
        self.numberOfLines = 0
        let attributedString = NSAttributedString(string: data as? String ?? "" , attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 28)
        ])
        self.attributedText = attributedString
    }
}

class MyLabel2: UILabel, Updatable{
    public func update(_ data: Any?) {
        self.backgroundColor = .gray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 12
        paragraphStyle.headIndent = 12
        paragraphStyle.tailIndent = -12
        paragraphStyle.alignment = .right
        self.numberOfLines = 0
        let attributedString = NSAttributedString(string: data as? String ?? "" , attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13)
            
        ])
        self.attributedText = attributedString
    }
}

class DiffableDataFactory{
    static func header(_ title: String)->AnyDiffableData {
        AnyDiffableData(title, viewClass: MyLabel.self, estimatedHeight: 1)
    }
    
    static func headerAndFooter(_ title: String, footer: String)->AnyDiffableData {
        AnyDiffableData(
            (AnyDiffableData(title, viewClass: MyLabel.self, estimatedHeight: 1),
             AnyDiffableData(footer, viewClass: MyLabel2.self, estimatedHeight: 1)), userDefinedHash: 1
        )
    }
}


