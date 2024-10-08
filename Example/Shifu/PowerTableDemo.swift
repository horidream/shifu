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

struct PowerTableDemo: View {
    @ObservedObject private var injectObserver = Self.injectionObserver
    @State var snapshot: NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>  = {
        var snapshot = NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>()
        snapshot.appendSections(["A", "宝"])
        var items = (1...2).map {AnyDiffableData("Super Man \($0)")}
        items.insert(DiffableDataFactory.margin(10, color: .red), at: 0)
        items.insert(DiffableDataFactory.scatterLabels(TableCellViewModelWithScatteredLabels(topLeft: "hello".attributedString([.foregroundColor: UIColor.blue, .font: UIFont.systemFont(ofSize: 20)]), topRight: "yes", bottomLeft: "ok", bottomRight: "fgogog")), at: 1)
        snapshot.appendItems(items, toSection: "A")
        snapshot.appendItems(["We won’t define default parameters at the Baz nor BazMock but we will use a protocol extension which will be the only place that the default values will be defined. That way both implementations of the same protocol have the same default values."], toSection: "宝")
        snapshot.update("A", items: (10...12).map {AnyDiffableData("Super Man \($0)")} + [DiffableDataFactory.margin(10, color: .green)])
        snapshot.appendSections([AnyDiffableData("c", estimatedHeight: 0), "D"])
        return snapshot
    }()
    @State var id = 1
    var loadMorePublisher: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    var body: some View {
        PowerTable(snapshot: $snapshot, delegate: MyCo(loadMorePublisher))
            .id(id)
            .navigationTitle("PowerTable Demo")
            .onReceive(loadMorePublisher) {
                snapshot.deleteItems([DiffableDataFactory.loadMoreCell()])
                let section1 = (
                    DiffableDataFactory.headerAndFooter("オリジナル劇場アニメ", footer: "2019 年 ‧ 科幻/爱情 ‧ 1 小时 38 分钟"),

                    (1...10).compactMap { _ -> AnyDiffableData? in
                        let now = Date.now
                        return now.stringify()?.wrap()
                    }
                )
                snapshot.update([section1])
                delay(0) {
                    snapshot.appendItems([DiffableDataFactory.loadMoreCell(self.loadMorePublisher)])
                }

            }
            .onInjection {
                sandbox()
            }
            .onAppear {
                sandbox()
            }
    }

    func sandbox() {
        id += 1
        snapshot.appendItems([DiffableDataFactory.loadMoreCell(loadMorePublisher)])
    }
}

extension String: @retroactive Wrappable {}
class MyCo: PowerTable.Coordinator {
    private var loadMorePublisher: PassthroughSubject<Void, Never>?
    init(_ loadMorePublisher: PassthroughSubject<Void, Never>?) {
        super.init()
        self.loadMorePublisher = loadMorePublisher
        self.defaultHeaderViewClass = MyLabel.self
        let v = UIImageView(image: UIImage(named: "cover"))
        v.contentMode = .scaleAspectFill
        v.frame = CGRect(0, 0, 100, 200)
        v.clipsToBounds = true
        self.tableHeaderView = v
        self.style = .plain
        //        self.sectionTitleTransformer = nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var snapshot = (tableView.dataSource as? UITableViewDiffableDataSource<AnyDiffableData, AnyDiffableData>)?.snapshot() {
            snapshot.appendItems([DiffableDataFactory.loadMoreCell(loadMorePublisher)])
            (tableView.dataSource as? UITableViewDiffableDataSource<AnyDiffableData, AnyDiffableData>)?.apply(snapshot)
        }
    }
}

class LoadMoreCell: UITableViewCell, Updatable {
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
        if let publisher = data as? PassthroughSubject<Void, Never> {
            spinner.startAnimating()
            delay(1) { [self] in
                spinner.stopAnimating()
                publisher.send()
            }
        }
    }
}

class MyLabel: UIView, Updatable {
    let label = UILabel(frame: .zero)
    init() {
        super.init(frame: .zero)
        self.addSubview(label)
        label.quickMargin(5, 0, 5, 0)
        self.addBorder(position: [.top], color: .white, lineWidth: 1)
            .addBorder(position: [.bottom], color: .black, lineWidth: 2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(_ data: Any?) {
        self.backgroundColor = .lightGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 12
        paragraphStyle.headIndent = 12
        paragraphStyle.tailIndent = -12
        let attributedString = NSAttributedString(string: data as? String ?? "", attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 22)
        ])
        label.numberOfLines = 0
        label.attributedText = attributedString
    }
}

class MyLabel2: UILabel, Updatable {
    public func update(_ data: Any?) {
        self.backgroundColor = .lightGray.withAlphaComponent(0.88)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 12
        paragraphStyle.headIndent = 12
        paragraphStyle.tailIndent = -12
        paragraphStyle.alignment = .right
        self.numberOfLines = 0
        let attributedString = NSAttributedString(string: data as? String ?? "", attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 13)

        ])
        self.attributedText = attributedString
    }
}

class MarginView: UITableViewCell, Updatable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func update(_ data: Any?) {
        if let data = data as? UIColor {
            self.backgroundColor = data
        }
    }
}

protocol StringLiternal {}
extension String: StringLiternal {}
extension NSAttributedString: StringLiternal {}
extension AttributedString: StringLiternal {}

struct TableCellViewModelWithScatteredLabels {
    var topLeft: StringLiternal?
    var topRight: StringLiternal?
    var bottomLeft: StringLiternal?
    var bottomRight: StringLiternal?
}

class ScatterLabels: UITableViewCell, Updatable {
    func update(_ data: Any?) {
        if let vm = data as? TableCellViewModelWithScatteredLabels {
            set(label: tl, text: vm.topLeft)
            set(label: tr, text: vm.topRight)
            set(label: bl, text: vm.bottomLeft)
            set(label: br, text: vm.bottomRight)
            selectionStyle = .none
        }
    }
    private func set(label: UILabel, text: StringLiternal?) {
        if let text = text as? String {
            label.text = text
        } else if let text = text as? NSAttributedString {
            label.attributedText = text
        } else if let text = text as? AttributedString {
            label.attributedText = text.ns
        }
    }

    private var tl = UILabel()
    private var tr = UILabel()
    private var bl = UILabel()
    private var br = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.addSubview(tl)
        contentView.addSubview(tr)
        contentView.addSubview(bl)
        contentView.addSubview(br)
        tl.quickAlign(1, 10, 10)
        tr.quickAlign(3, -10, 10)
        bl.quickAlign(7, 10, -10)
        br.quickAlign(9, -10, -10)
        NSLayoutConstraint.activate([bl.topAnchor.constraint(equalTo: tl.bottomAnchor, constant: 15)])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DiffableDataFactory {
    static func header(_ title: String) -> AnyDiffableData {
        AnyDiffableData(title, viewClass: MyLabel.self)
    }

    static func headerAndFooter(_ title: String, footer: String) -> AnyDiffableData {
        AnyDiffableData(
            (AnyDiffableData(title, viewClass: MyLabel.self, estimatedHeight: nil),
             AnyDiffableData(footer, viewClass: MyLabel2.self, estimatedHeight: 25)), userDefinedHash: 1
        )
    }

    static func loadMoreCell(_ publisher: Any? = nil) -> AnyDiffableData {
        AnyDiffableData(
            publisher, viewClass: LoadMoreCell.self, userDefinedHash: loadMoreCellID
        )
    }

    static func margin(_ height: CGFloat, color: UIColor = .clear) -> AnyDiffableData {
        AnyDiffableData(
            color, viewClass: MarginView.self, estimatedHeight: height, userDefinedHash: UUID()
        )
    }
    static func scatterLabels(_ texts: TableCellViewModelWithScatteredLabels) -> AnyDiffableData {
        AnyDiffableData(
            texts, viewClass: ScatterLabels.self, estimatedHeight: 100
        )
    }
}

let loadMoreCellID = UUID()
