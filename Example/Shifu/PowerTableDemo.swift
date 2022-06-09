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
import CryptoKit

struct PowerTableDemo:View{
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var snapshot:NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>  = {
        var snapshot = NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>()
        snapshot.appendSections(["A", "B"])
        snapshot.appendItems((1...2).map{AnyDiffableData("Super Man \($0)")}, toSection: "A")
        snapshot.appendItems(["We won’t define default parameters at the Baz nor BazMock but we will use a protocol extension which will be the only place that the default values will be defined. That way both implementations of the same protocol have the same default values."], toSection: "B")
        snapshot.update("A", items:(10...12).map{AnyDiffableData("Super Man \($0)")})
    
        return snapshot
    }()
    var loadMorePublisher: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    var body: some View{
        PowerTable(snapshot: $snapshot, delegate: MyCo(loadMorePublisher))
            .navigationTitle("PowerTable Demo")
            .onReceive(loadMorePublisher){
                snapshot.deleteItems([DiffableDataFactory.loadMoreCell()])
                let section1 = (
                    DiffableDataFactory.headerAndFooter("オリジナル劇場アニメ", footer: "2019 年 ‧ 科幻/爱情 ‧ 1 小时 38 分钟"),
                    
                    (1...10).map{ _ -> AnyDiffableData in
                        let now = Date.now
                        return AnyDiffableData(now.stringify(),userDefinedHash: now)
                    }
                )
                snapshot.update([section1])
                delay(0){
                    snapshot.appendItems([DiffableDataFactory.loadMoreCell(self.loadMorePublisher)])
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
        clg(Date.now)
        snapshot.appendItems([DiffableDataFactory.loadMoreCell(loadMorePublisher)])
    }
}



class MyCo: PowerTable.Coordinator{
    private var loadMorePublisher: PassthroughSubject<Void, Never>?
    init(_ loadMorePublisher: PassthroughSubject<Void, Never>?){
        super.init()
        self.loadMorePublisher = loadMorePublisher
        self.defaultHeaderViewClass = MyLabel.self
        let v = UIImageView(image: UIImage(named: "cover"))
        v.contentMode = .scaleAspectFill
        v.frame = CGRect(0,0, 100, 200)
        v.clipsToBounds = true
        self.tableHeaderView = v
        self.style = .plain
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var snapshot = (tableView.dataSource as? UITableViewDiffableDataSource<AnyDiffableData, AnyDiffableData>)?.snapshot(){
            snapshot.appendItems([DiffableDataFactory.loadMoreCell(loadMorePublisher)])
            (tableView.dataSource as? UITableViewDiffableDataSource<AnyDiffableData, AnyDiffableData>)?.apply(snapshot)
        }
    }
}

class LoadMoreCell:UITableViewCell, Updatable{
    let spinner = UIActivityIndicatorView(style: .medium)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(spinner)
        spinner.quickAlign()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func update(_ data: Any?) {
        if let publisher = data as? PassthroughSubject<Void, Never>{
            spinner.startAnimating()
            delay(1){ [self] in
                spinner.stopAnimating()
                publisher.send()
            }
        }
    }
}

class MyLabel: UIView, Updatable{
    let label = UILabel(frame: .zero)
    init(){
        super.init(frame: .zero)
        self.addSubview(label)
        label.quickMargin(0, 0, 0, 0)
            .addBorder(position: [.top, .bottom], color: .orange)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(_ data: Any?) {
        self.backgroundColor = .gray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 12
        paragraphStyle.headIndent = 12
        paragraphStyle.tailIndent = -12
        let attributedString = NSAttributedString(string: data as? String ?? "" , attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 28)
        ])
        label.numberOfLines = 0
        label.attributedText = attributedString
    }
}

class MyLabel2: UILabel, Updatable{
    public func update(_ data: Any?) {
        self.backgroundColor = .lightGray
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
            (AnyDiffableData(title, viewClass: MyLabel.self, estimatedHeight: 100),
             AnyDiffableData(footer, viewClass: MyLabel2.self, estimatedHeight: 100)), userDefinedHash: 1
        )
    }
    
    static func loadMoreCell(_ publisher: Any? = nil)->AnyDiffableData {
        AnyDiffableData(
            publisher, viewClass: LoadMoreCell.self, userDefinedHash: loadMoreCellID
        )
    }
}

let loadMoreCellID = UUID()

