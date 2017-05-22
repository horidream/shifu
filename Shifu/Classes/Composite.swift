//
//  Composite.swift
//  Pods
//
//  Created by Baoli Zhai on 23/05/2017.
//
//

import Foundation

public protocol Composite:class{
    associatedtype ChildType
    associatedtype ParentType
    var children:[ChildType]? { get set }
    var parent:ParentType? { get set }
    
    func addChild(_ child:ChildType)
    func insertChild(_ child:ChildType, at index:Int)
    func removeChild(at index:Int)
    func removeAllChild()
    func childAt(_ index:Int)->ChildType?
}


public extension Composite where ChildType:Composite{
    public func addChild(_ child:ChildType){
        child.parent = self as? ChildType.ParentType
        children?.append(child)
    }
    
    public func insertChild(_ child:ChildType, at index:Int)
    {
        child.parent = self as? ChildType.ParentType
        children?.insert(child, at: index)
    }
    
    public func removeChild(at index:Int){
        if( index < children?.count ?? 0 && index >= 0){
            children?[index].parent = nil
            children?.remove(at: index)
        }
    }
    
    public func removeAllChild(){
        children?.forEach { (item) in
            item.parent = nil
        }
        children = []
    }
    
    public func childAt(_ index:Int)->ChildType?{
        if(index>=0 && index<children?.count ?? 0){
            return children?[index]
        }
        return nil
    }
}

public extension Composite where ChildType:Equatable{
    public func removeChild(_ child:ChildType){
        if let index = children?.index(where: { $0 == child}){
            removeChild(at: index)
        }
    }
}

public extension Composite where ParentType:Composite,ParentType.ChildType:Equatable{
    public func removeFromParent(){
        self.parent?.removeChild(self as! ParentType.ChildType)
    }
}
