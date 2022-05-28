//
//  AnyDiffableData.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/5/27.
//

import SwiftUI
import UIKit


public struct PowerTable: UIViewControllerRepresentable{
    
    @Binding var snapshot:NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>
    let delegate: Coordinator
    let cellProvider: ((UITableView, IndexPath, AnyDiffableData)->UITableViewCell?)?
    public typealias UIViewControllerType = UITableViewController
    
    public init(snapshot: Binding<NSDiffableDataSourceSnapshot<AnyDiffableData, AnyDiffableData>>,  delegate: @autoclosure ()-> Coordinator = Coordinator(),  cellProvider: ((UITableView, IndexPath, AnyDiffableData)->UITableViewCell?)? = nil){
        _snapshot = snapshot
        self.delegate = delegate()
        self.cellProvider = cellProvider
    }
    public func makeCoordinator() -> Coordinator {
        return delegate
    }
    open class Coordinator: NSObject, UITableViewDelegate{
        public var dataSource: UITableViewDiffableDataSource<AnyDiffableData, AnyDiffableData>!
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let label = UILabel()
            label.text = self.dataSource.sectionIdentifier(for: section)?.payload as? String ?? ""
            label.backgroundColor = .darkGray
            label.textColor = .white
            return label
        }
        
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    }
    
    public func makeUIViewController(context: Context) -> UITableViewController {
        let tableViewController =  UITableViewController(style: .grouped)
        if let tableView = tableViewController.tableView {
            tableView.delegate = context.coordinator
            tableView.backgroundColor = .clear
            tableView.sectionFooterHeight = 0
            tableView.sectionHeaderHeight = 0
            tableView.sectionHeaderTopPadding = 0
            context.coordinator.dataSource = UITableViewDiffableDataSource(tableView: tableViewController.tableView, cellProvider: self.cellProvider ?? { tableView, indexPath, itemIdentifier in
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell?.selectionStyle = .none
                (cell as? Updatable)?.update(itemIdentifier)
                return cell
            })
        }
        return tableViewController
    }
    
    public func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        context.coordinator.dataSource.apply(snapshot)
    }
    
        
}
public struct AnyDiffableData: Hashable{
    static public func == (lhs: AnyDiffableData, rhs: AnyDiffableData) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    var viewClass: Updatable.Type?
    public var payload: Any?
    var userDefinedHash: AnyHashable?
    var uuid = UUID()
    public init(_ payload:Any?, userDefinedHash: @autoclosure ()->AnyHashable? = nil){
        self.payload = payload
        self.userDefinedHash = userDefinedHash()
    }
    
    public func hash(into hasher: inout Hasher) {
        if let userDefinedHash = userDefinedHash {
            hasher.combine(userDefinedHash)
        }else if let payload = payload as? AnyHashable{
            hasher.combine(payload)
        }else{
            hasher.combine(uuid)
        }
    }
}


extension AnyDiffableData: ExpressibleByStringLiteral{
    public init(stringLiteral value: String){
        self.init(value)
    }
}

public protocol Updatable{
    func update(_ data: Any?)
}

public extension NSDiffableDataSourceSnapshot where SectionIdentifierType == AnyDiffableData {
    mutating func addSection(_ section:AnyDiffableData){
        if(!self.sectionIdentifiers.contains(section)){
            self.appendSections([section])
        }
    }
    
}
