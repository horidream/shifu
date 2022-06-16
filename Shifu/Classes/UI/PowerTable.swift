//
//  AnyDiffableData.swift
//  Shifu
//
//  Created by Baoli Zhai on 2022/5/27.
//

import SwiftUI
import UIKit


public protocol DefaultTableSettings{
    var style: UITableView.Style? { get }
    var defaultHeaderViewClass: UIView.Type? { get }
    var defaultFooterViewClass: UIView.Type? { get }
}

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
    open class Coordinator: NSObject, DefaultTableSettings, UITableViewDelegate{
        public var style: UITableView.Style?
        public var tableHeaderView: UIView?
        public var defaultHeaderViewClass: UIView.Type?
        public var defaultFooterViewClass: UIView.Type?
        public var defaultCellViewClass: UIView.Type? = DefaultTableViewCell.self
        
        func defaultHeight(position: ViewPosition)-> CGFloat {
            switch position{
            case .header :
                return defaultHeaderViewClass == nil ? 0 : .leastNonzeroMagnitude
            case .footer :
                return defaultFooterViewClass == nil ? 0 : .leastNonzeroMagnitude
            }
        }
        
        public enum ViewPosition{
            case header, footer
        }
        
        public func defaultViewClass(for position: ViewPosition)-> UIView.Type? {
            switch  position {
            case .header:
                return defaultHeaderViewClass
            case .footer:
                return defaultFooterViewClass
            }
        }
        public var dataSource: UITableViewDiffableDataSource<AnyDiffableData, AnyDiffableData>!
        func view(for data: AnyDiffableData?, position: ViewPosition) -> UIView?{
            guard data?.estimatedHeight != 0 else {  return nil }
            var rst: UIView?
            if let viewClass = data?.viewClass as? UIView.Type, !(viewClass is UITableViewCell.Type) {
                rst = viewClass.init()
            }else{
                rst = defaultViewClass(for: position)?.init()
            }
            (rst as? Updatable)?.update(data?.payload)
            return rst
        }
        
        func footerIdentifier(section:Int) -> AnyDiffableData?{
            return (dataSource?.sectionIdentifier(for: section)?.payload as? (AnyDiffableData?,AnyDiffableData?))?.1
        }
        
        func headerIdentifier(section:Int) -> AnyDiffableData?{
            let sectionIdentier = dataSource?.sectionIdentifier(for: section)
            return (sectionIdentier?.payload as? (AnyDiffableData?,AnyDiffableData?))?.0 ?? sectionIdentier
        }
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return dataSource.itemIdentifier(for: indexPath)?.estimatedHeight ?? UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return dataSource.itemIdentifier(for: indexPath)?.estimatedHeight ?? UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return view(for: headerIdentifier(section: section), position: .header)
        }
        
        public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return headerIdentifier(section: section)?.estimatedHeight ?? defaultHeight(position: .header)
        }
        
        public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return view(for: footerIdentifier(section: section), position: .footer)
        }
        
        public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
            return footerIdentifier(section: section)?.estimatedHeight ?? defaultHeight(position: .footer)
        }
    }
    
    public func makeUIViewController(context: Context) -> UITableViewController {
        let tableViewController =  UITableViewController(style: context.coordinator.style ?? .grouped)
        if let tableView = tableViewController.tableView {
            
            tableView.backgroundColor = .clear
            tableView.sectionFooterHeight = 0
            tableView.sectionHeaderHeight = 0
            tableView.sectionHeaderTopPadding = 0
            tableView.tableHeaderView = context.coordinator.tableHeaderView
            context.coordinator.dataSource = UITableViewDiffableDataSource(tableView: tableViewController.tableView, cellProvider: self.cellProvider ?? { tableView, indexPath, itemIdentifier in
                if let viewClass = (itemIdentifier.viewClass as? UITableViewCell.Type) ?? (context.coordinator.defaultCellViewClass as? UITableViewCell.Type), let reuseIdentifier = itemIdentifier.reuseIdentifier{
                    tableView.register(viewClass, forCellReuseIdentifier: reuseIdentifier)
                    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
                    (cell as? Updatable)?.update(itemIdentifier.payload)
                    return cell
                }
                return nil
            })
            tableView.delegate = context.coordinator
        }
        return tableViewController
    }
    
    public func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
        context.coordinator.dataSource.apply(snapshot)
    }
    
        
}

public protocol ViewClass {}
extension UIView: ViewClass {}

public protocol TableViewCellModel: Hashable {
    associatedtype PayloadType
    var viewClass: ViewClass.Type? { get }
    var reuseIdentifier: String? { get }
    var payload: PayloadType? { get }
    var estimatedHeight: CGFloat? { get }
}

public extension TableViewCellModel {
    var reuseIdentifier: String? { String(describing: viewClass) }
}

public struct AnyDiffableData: TableViewCellModel, Wrappable{
    static public func == (lhs: AnyDiffableData, rhs: AnyDiffableData) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public var viewClass: ViewClass.Type?
    public var estimatedHeight: CGFloat?
    public var payload: Any?
    var userDefinedHash: AnyHashable?
    var uuid = UUID()
    
    public init(
        _ payload:Any? = nil,
        viewClass: ViewClass.Type? = nil,
        estimatedHeight: CGFloat? = nil,
        userDefinedHash: @autoclosure ()->AnyHashable? = nil)
    {
        self.payload = payload
        self.viewClass = viewClass
        self.estimatedHeight = estimatedHeight
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

public protocol Wrappable{
    func wrap(_ viewClass: ViewClass.Type?, estimatedHeight: CGFloat?, userDefinedHash: @autoclosure ()->AnyHashable?)->AnyDiffableData
}

public extension Wrappable{
    func wrap(
        _ viewClass: ViewClass.Type? = nil,
        estimatedHeight: CGFloat? = nil,
        userDefinedHash: @autoclosure ()->AnyHashable? = nil)->AnyDiffableData{
        return self as? AnyDiffableData ?? AnyDiffableData(self, viewClass: viewClass, estimatedHeight: estimatedHeight, userDefinedHash: userDefinedHash())
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

//public protocol UpdatableCell: UITableViewCell, Updatable { }

public extension Updatable where Self: UITableViewCell{
    public func update(_ data: Any?)  {
        self.selectionStyle = .none
        self.textLabel?.numberOfLines = 0
        if let text = data as? String{
            self.textLabel?.text = text
        }else{
            self.textLabel?.text = String(describing: data!)
        }
    }
}

public extension NSDiffableDataSourceSnapshot where SectionIdentifierType == AnyDiffableData {
    mutating func addSection(_ section:AnyDiffableData){
        if(!self.sectionIdentifiers.contains(section)){
            self.appendSections([section])
        }
    }
    
    mutating func update(_ section: AnyDiffableData, items: [AnyDiffableData], reset: Bool = false) where ItemIdentifierType == AnyDiffableData{
        if reset {
            deleteSections([section])
        }
        addSection(section)
        appendItems(items, toSection: section)
    }
    
    mutating func update(_ data: [(Wrappable, [Wrappable])], reset: Bool = false) where ItemIdentifierType == AnyDiffableData{
        for (section, items) in data{
            if reset {
                deleteSections([section.wrap()])
            }
            addSection(section.wrap())
            appendItems(items.map{ $0.wrap() }, toSection: section.wrap())
        }
    }
    
    mutating func update(_ data: [(AnyDiffableData, [AnyDiffableData])], reset: Bool = false) where ItemIdentifierType == AnyDiffableData{
        for (section, items) in data{
            if reset {
                deleteSections([section])
            }
            addSection(section)
            appendItems(items, toSection: section)
        }
    }
}


public class DefaultTableViewCell: UITableViewCell, Updatable { }
