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

//public extension DefaultTableSettings{
//    var style: UITableView.Style? { nil }
//    var defaultHeaderViewClass: UIView.Type? { nil }
//    var defaultFooterViewClass: UIView.Type? { nil }
//}

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
        
        public var defaultHeaderViewClass: UIView.Type?
        public var defaultFooterViewClass: UIView.Type?
        
        func defaultHeight(position: ViewPosition)-> CGFloat {
            switch position{
            case .header :
                return defaultHeaderViewClass == nil ? 0 : .minimumMagnitude(1, 1)
            case .footer :
                return defaultFooterViewClass == nil ? 0 : .minimumMagnitude(1, 1)
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
            return (dataSource.sectionIdentifier(for: section)?.payload as? (AnyDiffableData?,AnyDiffableData?))?.1
        }
        
        func headerIdentifier(section:Int) -> AnyDiffableData?{
            let sectionIdentier = dataSource.sectionIdentifier(for: section)
            return (sectionIdentier?.payload as? (AnyDiffableData?,AnyDiffableData?))?.0 ?? sectionIdentier
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
            tableView.delegate = context.coordinator
            tableView.backgroundColor = .clear
            tableView.sectionFooterHeight = 0
            tableView.sectionHeaderHeight = 0
            tableView.sectionHeaderTopPadding = 0
            context.coordinator.dataSource = UITableViewDiffableDataSource(tableView: tableViewController.tableView, cellProvider: self.cellProvider ?? { tableView, indexPath, itemIdentifier in
                if let viewClass = itemIdentifier.viewClass as? UITableViewCell.Type, let reuseIdentifier = itemIdentifier.reuseIdentifier{
                    tableView.register(viewClass, forCellReuseIdentifier: reuseIdentifier)
                    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
                    (cell as? Updatable)?.update(itemIdentifier)
                    return cell
                }
                return nil
            })
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
    var estimatedHeight: CGFloat? { 0 }
}

public struct AnyDiffableData: TableViewCellModel{
    static public func == (lhs: AnyDiffableData, rhs: AnyDiffableData) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public static var defaultViewClassFactory: ((Any? ) -> ViewClass.Type)? = { _ in
        DefaultTableViewCell.self
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
        self.viewClass = viewClass ?? AnyDiffableData.defaultViewClassFactory?(payload)
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


extension AnyDiffableData: ExpressibleByStringLiteral{
    public init(stringLiteral value: String){
        self.init(value)
    }
}

public protocol Updatable{
    func update(_ data: Any?)
}

public protocol UpdatableCell: UITableViewCell, Updatable, ViewClass { }

public extension Updatable where Self: UITableViewCell{
    public func update(_ data: Any?)  {
        if let data = data as? AnyDiffableData, let text = data.payload as? String{
            self.selectionStyle = .none
            self.textLabel?.numberOfLines = 0
            self.textLabel?.text = text
        }
    }
}

public extension NSDiffableDataSourceSnapshot where SectionIdentifierType == AnyDiffableData {
    mutating func addSection(_ section:AnyDiffableData){
        if(!self.sectionIdentifiers.contains(section)){
            self.appendSections([section])
        }
    }
}


public class DefaultTableViewCell: UITableViewCell, UpdatableCell { }
